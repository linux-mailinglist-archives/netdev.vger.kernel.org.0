Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5BCC53002
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 12:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbfFYKgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 06:36:15 -0400
Received: from mail1.windriver.com ([147.11.146.13]:58842 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbfFYKgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 06:36:14 -0400
Received: from ALA-HCB.corp.ad.wrs.com ([147.11.189.41])
        by mail1.windriver.com (8.15.2/8.15.1) with ESMTPS id x5PAa8bA026036
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Tue, 25 Jun 2019 03:36:08 -0700 (PDT)
Received: from ALA-MBD.corp.ad.wrs.com ([169.254.3.194]) by
 ALA-HCB.corp.ad.wrs.com ([147.11.189.41]) with mapi id 14.03.0439.000; Tue,
 25 Jun 2019 03:36:07 -0700
From:   "Hallsmark, Per" <Per.Hallsmark@windriver.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Hallsmark, Per" <Per.Hallsmark@windriver.com>
Subject: [PATCH] let proc net directory inodes reflect to active net
 namespace
Thread-Topic: [PATCH] let proc net directory inodes reflect to active net
 namespace
Thread-Index: AQHVK0C2SQYwxDnNd0ORdMMwE+Y4tg==
Date:   Tue, 25 Jun 2019 10:36:06 +0000
Message-ID: <B7B4BB465792624BAF51F33077E99065DC5D7225@ALA-MBD.corp.ad.wrs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [128.224.18.181]
Content-Type: multipart/mixed;
        boundary="_005_B7B4BB465792624BAF51F33077E99065DC5D7225ALAMBDcorpadwrs_"
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_005_B7B4BB465792624BAF51F33077E99065DC5D7225ALAMBDcorpadwrs_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

Linux kernel recently got a bugfix 1fde6f21d90f ("proc: fix /proc/net/* aft=
er setns(2)"),
but unfortunately it only solves the issue for procfs net file inodes so th=
ey get correct
content after a process change namespace.

Checking on a v5.2-rc6 kernel :

sh-4.4# sh netns_procfs_test.sh
[   16.451640] ip (108) used greatest stack depth: 12264 bytes left
Before net namespace change :
=3D=3D=3D=3D /proc/net/dev =3D=3D=3D=3D
Inter-|   Receive                                                |  Transmi=
t
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    =
packd
  eth0:       0       0    0    0    0     0          0         0        0 =
    0
    lo:       0       0    0    0    0     0          0         0        0 =
    0
if_default:       0       0    0    0    0     0          0         0      =
  0 0
  sit0:       0       0    0    0    0     0          0         0        0 =
    0

=3D=3D=3D=3D files in /proc/net/dev_snmp6 =3D=3D=3D=3D
  .
  ..
  lo
  eth0
  sit0
  if_default


After net namespace change :
=3D=3D=3D=3D /proc/net/dev =3D=3D=3D=3D
Inter-|   Receive                                                |  Transmi=
t
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    =
packd
  sit0:       0       0    0    0    0     0          0         0        0 =
    0
if_other:       0       0    0    0    0     0          0         0        =
0   0
    lo:       0       0    0    0    0     0          0         0        0 =
    0

=3D=3D=3D=3D files in /proc/net/dev_snmp6 =3D=3D=3D=3D
  .
  ..
  lo
  eth0
  sit0
  if_default
This kernel is fixed for file inode bug but suffers dir inode bug
sh-4.4#

As can be seen above, after the namespace change we see new content in proc=
fs net/dev
but the listing of procfs net/dev_snmp6 still shows entries from previous n=
amespace.
We need to apply similar bugfix for directory creation in procfs net as the=
 mentioned
commit do for files.

Checking on a v5.2-rc6 kernel with bugfixes :

sh-4.4# sh netns_procfs_test.sh
[  745.993882] ip (108) used greatest stack depth: 12264 bytes left
Before net namespace change :
=3D=3D=3D=3D /proc/net/dev =3D=3D=3D=3D
Inter-|   Receive                                                |  Transmi=
t
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    =
packd
    lo:       0       0    0    0    0     0          0         0        0 =
    0
  sit0:       0       0    0    0    0     0          0         0        0 =
    0
  eth0:       0       0    0    0    0     0          0         0        0 =
    0
if_default:       0       0    0    0    0     0          0         0      =
  0 0

=3D=3D=3D=3D files in /proc/net/dev_snmp6 =3D=3D=3D=3D
  .
  ..
  lo
  eth0
  sit0
  if_default


After net namespace change :
=3D=3D=3D=3D /proc/net/dev =3D=3D=3D=3D
Inter-|   Receive                                                |  Transmi=
t
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    =
packd
if_other:       0       0    0    0    0     0          0         0        =
0   0
  sit0:       0       0    0    0    0     0          0         0        0 =
    0
    lo:       0       0    0    0    0     0          0         0        0 =
    0

=3D=3D=3D=3D files in /proc/net/dev_snmp6 =3D=3D=3D=3D
  .
  ..
  lo
  sit0
  if_other
This kernel is fixed for both file and dir inode bug
sh-4.4#

Here we see that the directory procfs net/dev_snmp6 is updated according to=
 the namespace
change.

The fix is two commits, first updates proc_net_mkdir() entries similar to m=
entioned patch
and second one is changing net/ipv6/proc.c to use proc_net_mkdir() instead.

Speaking about proc_net_mkdir()...

[phallsma@arn-phallsma-l3 linux]$ git grep proc_mkdir | grep proc_net
drivers/isdn/divert/divert_procfs.c:    isdn_proc_entry =3D proc_mkdir("isd=
n", init_net.proc_net);
drivers/isdn/hysdn/hysdn_procconf.c:    hysdn_proc_entry =3D proc_mkdir(PRO=
C_SUBDIR_NAME, init_net.proc_net);
drivers/net/bonding/bond_procfs.c:              bn->proc_dir =3D proc_mkdir=
(DRV_NAME, bn->net->proc_net);
drivers/net/wireless/intel/ipw2x00/libipw_module.c:     libipw_proc =3D pro=
c_mkdir(DRV_PROCNAME, init_net.proc_net);
drivers/net/wireless/intersil/hostap/hostap_main.c:             hostap_proc=
 =3D proc_mkdir("hostap", init_net.proc_net);
drivers/staging/rtl8192u/ieee80211/ieee80211_module.c:  ieee80211_proc =3D =
proc_mkdir(DRV_NAME, init_net.proc_net);
drivers/staging/rtl8192u/r8192U_core.c: rtl8192_proc =3D proc_mkdir(RTL819X=
U_MODULE_NAME, init_net.proc_net);
net/appletalk/atalk_proc.c:     if (!proc_mkdir("atalk", init_net.proc_net)=
)
net/core/pktgen.c:      pn->proc_dir =3D proc_mkdir(PG_PROC_DIR, pn->net->p=
roc_net);
net/ipv4/netfilter/ipt_CLUSTERIP.c:     cn->procdir =3D proc_mkdir("ipt_CLU=
STERIP", net->proc_net);
net/ipv6/proc.c:        net->mib.proc_net_devsnmp6 =3D proc_mkdir("dev_snmp=
6", net->proc_net);
net/llc/llc_proc.c:     llc_proc_dir =3D proc_mkdir("llc", init_net.proc_ne=
t);
net/netfilter/xt_hashlimit.c:   hashlimit_net->ipt_hashlimit =3D proc_mkdir=
("ipt_hashlimit", net->proc_net);
net/netfilter/xt_hashlimit.c:   hashlimit_net->ip6t_hashlimit =3D proc_mkdi=
r("ip6t_hashlimit", net->proc_net);
net/netfilter/xt_recent.c:      recent_net->xt_recent =3D proc_mkdir("xt_re=
cent", net->proc_net);
net/sunrpc/cache.c:     cd->procfs =3D proc_mkdir(cd->name, sn->proc_net_rp=
c);
net/sunrpc/stats.c:     sn->proc_net_rpc =3D proc_mkdir("rpc", net->proc_ne=
t);
net/x25/x25_proc.c:     if (!proc_mkdir("x25", init_net.proc_net))
[phallsma@arn-phallsma-l3 linux]$

IMHO all code should use proc_net_mkdir() instead of proc_mkdir() for procf=
s net entries,
or am I missing something here? If not possible to changeover to proc_net_m=
kdir() there
is a need for duplicating my first commit at those places. I'm fixing the o=
ne for dev_snmp6()
which is what I've tested as well.

Also wonder if it all is optimal. Wouldn't it be better to re-enable dcache=
 for these (files as well as directories)
and in addition have kernel drop dcache in case of a namespace change?

Attaching patches and app/script for verifying.

I'm not on the mailing lists so please keep me on CC in case of responding.

Best regards,
Per

--
Per Hallsmark                        per.hallsmark@windriver.com
Senior Member Technical Staff        Wind River AB
Mobile: +46733249340                 Office: +46859461127
Torshamnsgatan 27                    164 40 Kista

--_005_B7B4BB465792624BAF51F33077E99065DC5D7225ALAMBDcorpadwrs_
Content-Type: text/x-patch;
	name="0001-Make-directory-inodes-in-proc-net-adhere-to-net-name.patch"
Content-Description: 0001-Make-directory-inodes-in-proc-net-adhere-to-net-name.patch
Content-Disposition: attachment;
	filename="0001-Make-directory-inodes-in-proc-net-adhere-to-net-name.patch";
	size=1895; creation-date="Tue, 25 Jun 2019 09:59:28 GMT";
	modification-date="Tue, 25 Jun 2019 09:59:28 GMT"
Content-Transfer-Encoding: base64

RnJvbSA2Njc2OWFmMWY5MzExMjRkYTFhYTA0YjM0MzUwYjM2MjNhOTAwM2UzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQZXIgSGFsbHNtYXJrIDxwZXIuaGFsbHNtYXJrQHdpbmRyaXZl
ci5jb20+CkRhdGU6IFdlZCwgMTkgSnVuIDIwMTkgMTU6NDY6MzkgKzAyMDAKU3ViamVjdDogW1BB
VENIIDEvMl0gTWFrZSBkaXJlY3RvcnkgaW5vZGVzIGluIC9wcm9jL25ldCBhZGhlcmUgdG8gbmV0
CiBuYW1lc3BhY2UKClRoaXMgcGF0Y2ggZml4ZXMgL3Byb2MvbmV0IGRpcmVjdG9yeSBpbm9kZXMg
aW4gc2ltaWxhciB3YXkgYXMKY29tbWl0IDFmZGU2ZjIxZDkwZiAoInByb2M6IGZpeCAvcHJvYy9u
ZXQvKiBhZnRlciBzZXRucygyKSIpCmZpeGVzIGZpbGUgaW5vZGVzLgoKU2lnbmVkLW9mZi1ieTog
UGVyIEhhbGxzbWFyayA8cGVyLmhhbGxzbWFya0B3aW5kcml2ZXIuY29tPgotLS0KIGZzL3Byb2Mv
cHJvY19uZXQuYyAgICAgIHwgMTIgKysrKysrKysrKysrCiBpbmNsdWRlL2xpbnV4L3Byb2NfZnMu
aCB8ICA3ICsrLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygrKSwgNSBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9wcm9jL3Byb2NfbmV0LmMgYi9mcy9wcm9jL3Byb2Nf
bmV0LmMKaW5kZXggNzZhZTI3OGRmMWM0Li4xYzQyMzFhNjBjOWUgMTAwNjQ0Ci0tLSBhL2ZzL3By
b2MvcHJvY19uZXQuYworKysgYi9mcy9wcm9jL3Byb2NfbmV0LmMKQEAgLTU1LDYgKzU1LDE4IEBA
IHN0YXRpYyB2b2lkIHBkZV9mb3JjZV9sb29rdXAoc3RydWN0IHByb2NfZGlyX2VudHJ5ICpwZGUp
CiAJcGRlLT5wcm9jX2RvcHMgPSAmcHJvY19uZXRfZGVudHJ5X29wczsKIH0KIAorc3RydWN0IHBy
b2NfZGlyX2VudHJ5ICpwcm9jX25ldF9ta2RpcihzdHJ1Y3QgbmV0ICpuZXQsIGNvbnN0IGNoYXIg
Km5hbWUsCisJCQkJICAgICAgc3RydWN0IHByb2NfZGlyX2VudHJ5ICpwYXJlbnQpCit7CisJc3Ry
dWN0IHByb2NfZGlyX2VudHJ5ICpwZGU7CisKKwlwZGUgPSBwcm9jX21rZGlyX2RhdGEobmFtZSwg
MCwgcGFyZW50LCBuZXQpOworCXBkZS0+cHJvY19kb3BzID0gJnByb2NfbmV0X2RlbnRyeV9vcHM7
CisKKwlyZXR1cm4gcGRlOworfQorRVhQT1JUX1NZTUJPTChwcm9jX25ldF9ta2Rpcik7CisKIHN0
YXRpYyBpbnQgc2VxX29wZW5fbmV0KHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpm
aWxlKQogewogCXVuc2lnbmVkIGludCBzdGF0ZV9zaXplID0gUERFKGlub2RlKS0+c3RhdGVfc2l6
ZTsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcHJvY19mcy5oIGIvaW5jbHVkZS9saW51eC9w
cm9jX2ZzLmgKaW5kZXggNTJhMjgzYmEwNDY1Li42MDhiOGExMGUzMzggMTAwNjQ0Ci0tLSBhL2lu
Y2x1ZGUvbGludXgvcHJvY19mcy5oCisrKyBiL2luY2x1ZGUvbGludXgvcHJvY19mcy5oCkBAIC0x
MjQsMTEgKzEyNCw4IEBAIHN0YXRpYyBpbmxpbmUgc3RydWN0IHBpZCAqdGdpZF9waWRmZF90b19w
aWQoY29uc3Qgc3RydWN0IGZpbGUgKmZpbGUpCiAKIHN0cnVjdCBuZXQ7CiAKLXN0YXRpYyBpbmxp
bmUgc3RydWN0IHByb2NfZGlyX2VudHJ5ICpwcm9jX25ldF9ta2RpcigKLQlzdHJ1Y3QgbmV0ICpu
ZXQsIGNvbnN0IGNoYXIgKm5hbWUsIHN0cnVjdCBwcm9jX2Rpcl9lbnRyeSAqcGFyZW50KQotewot
CXJldHVybiBwcm9jX21rZGlyX2RhdGEobmFtZSwgMCwgcGFyZW50LCBuZXQpOwotfQorZXh0ZXJu
IHN0cnVjdCBwcm9jX2Rpcl9lbnRyeSAqcHJvY19uZXRfbWtkaXIoCisJc3RydWN0IG5ldCAqbmV0
LCBjb25zdCBjaGFyICpuYW1lLCBzdHJ1Y3QgcHJvY19kaXJfZW50cnkgKnBhcmVudCk7CiAKIHN0
cnVjdCBuc19jb21tb247CiBpbnQgb3Blbl9yZWxhdGVkX25zKHN0cnVjdCBuc19jb21tb24gKm5z
LAotLSAKMi4yMC4xCgo=

--_005_B7B4BB465792624BAF51F33077E99065DC5D7225ALAMBDcorpadwrs_
Content-Type: text/x-patch;
	name="0002-net-Directories-created-in-proc-net-should-be-done-v.patch"
Content-Description: 0002-net-Directories-created-in-proc-net-should-be-done-v.patch
Content-Disposition: attachment;
	filename="0002-net-Directories-created-in-proc-net-should-be-done-v.patch";
	size=976; creation-date="Tue, 25 Jun 2019 09:59:37 GMT";
	modification-date="Tue, 25 Jun 2019 09:59:37 GMT"
Content-Transfer-Encoding: base64

RnJvbSA2OTI1YTU0MDhmZmNlMzdkYzcxODcxYzJlZTA1ZGI5NmU2MGNhZTBkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQZXIgSGFsbHNtYXJrIDxwZXIuaGFsbHNtYXJrQHdpbmRyaXZl
ci5jb20+CkRhdGU6IFRodSwgMjAgSnVuIDIwMTkgMTA6MjE6MzEgKzAyMDAKU3ViamVjdDogW1BB
VENIIDIvMl0gbmV0OiBEaXJlY3RvcmllcyBjcmVhdGVkIGluIC9wcm9jL25ldCBzaG91bGQgYmUg
ZG9uZSB2aWEKIHByb2NfbmV0X21rZGlyKCkKCkRpcmVjdG9yaWVzIGNyZWF0ZWQgaW4gL3Byb2Mv
bmV0IHNob3VsZCBiZSBkb25lIHZpYSBwcm9jX25ldF9ta2RpcigpCgpTaWduZWQtb2ZmLWJ5OiBQ
ZXIgSGFsbHNtYXJrIDxwZXIuaGFsbHNtYXJrQHdpbmRyaXZlci5jb20+Ci0tLQogbmV0L2lwdjYv
cHJvYy5jIHwgMyArKy0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkKCmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9wcm9jLmMgYi9uZXQvaXB2Ni9wcm9jLmMKaW5k
ZXggNGE4ZGE2Nzk4NjZlLi4zNzI4YzU3ZTkzZGMgMTAwNjQ0Ci0tLSBhL25ldC9pcHY2L3Byb2Mu
YworKysgYi9uZXQvaXB2Ni9wcm9jLmMKQEAgLTI4Miw3ICsyODIsOCBAQCBzdGF0aWMgaW50IF9f
bmV0X2luaXQgaXB2Nl9wcm9jX2luaXRfbmV0KHN0cnVjdCBuZXQgKm5ldCkKIAkJCXNubXA2X3Nl
cV9zaG93LCBOVUxMKSkKIAkJZ290byBwcm9jX3NubXA2X2ZhaWw7CiAKLQluZXQtPm1pYi5wcm9j
X25ldF9kZXZzbm1wNiA9IHByb2NfbWtkaXIoImRldl9zbm1wNiIsIG5ldC0+cHJvY19uZXQpOwor
CW5ldC0+bWliLnByb2NfbmV0X2RldnNubXA2ID0gcHJvY19uZXRfbWtkaXIobmV0LAorCQkJCQkJ
ICAgICJkZXZfc25tcDYiLCBuZXQtPnByb2NfbmV0KTsKIAlpZiAoIW5ldC0+bWliLnByb2NfbmV0
X2RldnNubXA2KQogCQlnb3RvIHByb2NfZGV2X3NubXA2X2ZhaWw7CiAJcmV0dXJuIDA7Ci0tIAoy
LjIwLjEKCg==

--_005_B7B4BB465792624BAF51F33077E99065DC5D7225ALAMBDcorpadwrs_
Content-Type: text/x-csrc; name="netns_procfs_test.c"
Content-Description: netns_procfs_test.c
Content-Disposition: attachment; filename="netns_procfs_test.c"; size=3920;
	creation-date="Tue, 25 Jun 2019 10:28:40 GMT";
	modification-date="Tue, 25 Jun 2019 10:28:40 GMT"
Content-Transfer-Encoding: base64

LyoKICBWZXJpZmllciBvZiAvcHJvYy9uZXQgYW5kIG5ldCBuYW1lc3BhY2UgY29uc2lzdGVuY3kK
ICBBdXRob3IgOiBQZXIgSGFsbHNtYXJrIDxwZXIuaGFsbHNtYXJrQHdpbmRyaXZlci5jb20+Cgog
IEZpcnN0IHNldHVwIGEgbmV0IG5hbWVzcGFjZSBhbmQgYWRkIGEgdmV0aCBzbyB3ZSBnZXQgc29t
ZXRoaW5nIHRvIHRlc3Qgd2l0aAoKICBpcCBuZXRucyBhZGQgbmV0bnNfb3RoZXIKICBpcCBsaW5r
IGFkZCBpZl9kZWZhdWx0IHR5cGUgdmV0aCBwZWVyIG5hbWUgaWZfb3RoZXIKICBpcCBsaW5rIHNl
dCBpZl9vdGhlciBuZXRucyBuZXRuc19vdGhlcgoKICBSdW4gdGVzdCBhcHAgd2l0aG91dCBmaXJz
dCByZWFkaW5nIHNvbWUgaW5mbyBmcm9tIC9wcm9jL25ldCBpbiBkZWZhdWx0IG5hbWVzcGFjZQoK
ICAuL25ldG5zX3Byb2Nmc190ZXN0CgogIFJ1biB0ZXN0IGFwcCBhZ2FpbiwgdGhpcyB0aW1lIHJl
YWRpbmcgc29tZSBpbmZvIGZyb20gL3Byb2MvbmV0IGluIGRlZmF1bHQgbmFtZXNwYWNlCiAgYmVm
b3JlIGNoYW5naW5nIG5ldCBuYW1lc3BhY2UKCiAgLi9uZXRuc19wcm9jZnNfdGVzdCBjYWNoZWQK
CiAgT24gYSBidWdmcmVlIGtlcm5lbCwgdGhlIG91dHB1dCBhZnRlciAiQWZ0ZXIgbmV0IG5hbWVz
cGFjZSBjaGFuZ2UiIHNob3VsZCBiZSBzYW1lIGFzCiAgaW4gZmlyc3QgdGVzdCBydW4sIG1lYW5p
bmcgd2Ugc2hvdWxkIHNlZSBpZl9vdGhlciBpbiB0aGUgL3Byb2MvbmV0L2RldiBkdW1wIGFuZCB3
ZQogIHNob3VsZCBzZWUgaWZfb3RoZXIgaW4gdGhlIGRpcmVjdG9yeS4KCiAgVGhlIGlzc3VlIGlz
IG5vdCB2aXNpYmxlIGlmIGl0IGlzIGRpZmZlcmVudCBwcm9jZXNzZXMgZG9pbmcgdGhlIHJlYWRp
bmdzIHNpbmNlIHRoZW4KICB0aGUgaW5vZGUncyBhcmVuJ3QgY2FjaGVkLgoqLwoKCiNkZWZpbmUg
X0dOVV9TT1VSQ0UKI2luY2x1ZGUgPHNjaGVkLmg+CgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1
ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CiNpbmNsdWRlIDxlcnJuby5oPgojaW5j
bHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxhc3NlcnQuaD4KI2luY2x1ZGUgPGZjbnRsLmg+CiNp
bmNsdWRlIDxlcnJuby5oPgojaW5jbHVkZSA8bGltaXRzLmg+CiNpbmNsdWRlIDxzeXMvdHlwZXMu
aD4KI2luY2x1ZGUgPHN5cy9tb3VudC5oPgojaW5jbHVkZSA8ZXJybm8uaD4KI2luY2x1ZGUgPGRp
cmVudC5oPgoKI2RlZmluZSBORVROU19SVU5fRElSICIvdmFyL3J1bi9uZXRucyIKCnN0YXRpYyBp
bnQgZ2V0X25zZmQoY29uc3QgY2hhciAqbnMpCnsKICAgIGNoYXIgcGF0aFtzdHJsZW4oTkVUTlNf
UlVOX0RJUikgKyBzdHJsZW4obnMpICsgMl07CiAgICBpbnQgZmQ7CiAgICBzbnByaW50ZihwYXRo
LCBzaXplb2YocGF0aCksICIlcy8lcyIsIE5FVE5TX1JVTl9ESVIsIG5zKTsKICAgIGZkID0gb3Bl
bihwYXRoLCBPX1JET05MWSwgMCk7CiAgICByZXR1cm4gZmQ7Cn0KCnN0YXRpYyBpbnQgZHVtcF9m
aWxlKGNvbnN0IGNoYXIgKmZuLCBjb25zdCBpbnQgY2hlY2tmb3JidWcpCnsKCWludCBmZDsKCWNo
YXIgYnVmWzUxMl07Cglzc2l6ZV90IGxlbjsKCWNoYXIgKndob2xlYnVmID0gTlVMTDsKCXNzaXpl
X3Qgd2hvbGVsZW4gPSAwOwoJaW50IHN0YXR1cyA9IDA7CgoJcHJpbnRmKCI9PT09ICVzID09PT1c
biIsIGZuKTsKCglmZCA9IG9wZW4oZm4sIE9fUkRPTkxZKTsKCWlmIChmZCA9PSAtMSkgewoJCXBy
aW50ZigiQ291bGRuJ3Qgb3BlbiAlcyAoJXMpXG4iLCBmbiwgc3RyZXJyb3IoZXJybm8pKTsKCQly
ZXR1cm4gLTE7Cgl9CgoJZG8gewoJCWxlbiA9IHJlYWQoZmQsIGJ1Ziwgc2l6ZW9mKGJ1ZiktMSk7
CgkJYnVmW2xlbl0gPSAwOwoJCXdob2xlYnVmID0gcmVhbGxvYyh3aG9sZWJ1Ziwgd2hvbGVsZW4g
KyBsZW4gKyAxKTsKCQlzcHJpbnRmKCZ3aG9sZWJ1Zlt3aG9sZWxlbl0sICIlcyIsIGJ1Zik7CgkJ
d2hvbGVsZW4gKz0gbGVuOwoJfSB3aGlsZSAobGVuID4gMCk7CglwcmludGYoIiVzXG4iLCB3aG9s
ZWJ1Zik7CglpZiAoY2hlY2tmb3JidWcgJiYgc3Ryc3RyKHdob2xlYnVmLCAiaWZfb3RoZXIiKSkg
ewoJCXN0YXR1cyA9IDE7Cgl9CgoJZnJlZSh3aG9sZWJ1Zik7CgljbG9zZShmZCk7CgoJcmV0dXJu
IHN0YXR1czsKfQoKc3RhdGljIGludCBkdW1wX2Rpcihjb25zdCBjaGFyICpkbiwgY29uc3QgaW50
IGNoZWNrZm9yYnVnKQp7CglESVIgKmRpcjsKCXN0cnVjdCBkaXJlbnQgKmRpcl9lbnRyeTsKCWlu
dCBzdGF0dXMgPSAwOwoKCXByaW50ZigiPT09PSBmaWxlcyBpbiAlcyA9PT09XG4iLCBkbik7CgoJ
ZGlyID0gb3BlbmRpcihkbik7CglpZiAoIWRpcikgewoJCXByaW50ZigiQ291bGRuJ3Qgb3BlbiAl
cyAoJXMpXG4iLCBkbiwgc3RyZXJyb3IoZXJybm8pKTsKCQlyZXR1cm4gLTE7Cgl9CgoJd2hpbGUg
KChkaXJfZW50cnkgPSByZWFkZGlyKGRpcikpICE9IE5VTEwpIHsKCQlwcmludGYoIiAgJXMiLCBk
aXJfZW50cnktPmRfbmFtZSk7CgkJaWYgKGNoZWNrZm9yYnVnICYmICFzdHJjbXAoZGlyX2VudHJ5
LT5kX25hbWUsICJpZl9vdGhlciIpKSB7CgkJCXN0YXR1cyA9IDI7CgkJfQoJCXByaW50ZigiXG4i
KTsKICAgICAgICB9CgoJY2xvc2VkaXIoZGlyKTsKCglyZXR1cm4gc3RhdHVzOwp9CgpzdGF0aWMg
aW50IHN3aXRjaF9ucyhjb25zdCBjaGFyICpucykKewogICAgaW50IG5zZmQgPSBnZXRfbnNmZChu
cyk7CgogICAgaWYgKHNldG5zKG5zZmQsIENMT05FX05FV05FVCkgPCAwKSB7CiAgICAgICAgZnBy
aW50ZihzdGRlcnIsICJVbmFibGUgdG8gc3dpdGNoIHRvIG5hbWVzcGFjZShmZD0lZCk6ICVzLlxu
IiwKICAgICAgICAgICAgICAgIG5zZmQsIHN0cmVycm9yKGVycm5vKSk7CiAgICAgICAgZXhpdCgt
MSk7CiAgICB9CiAgICByZXR1cm4gMDsKfQoKaW50IG1haW4gKGludCBhcmdjLCBjaGFyICoqYXJn
dikKewoJaW50IGJ1Z2NoZWNrID0gMDsKCWludCBjaGVja2ZvcmJ1ZyA9IDE7CglpZiAoYXJnYyA9
PSAyICYmICFzdHJjbXAoYXJndlsxXSwgImNhY2hlZCIpKSB7CgkJLy8gYWNjZXNzIC9wcm9jL25l
dCBhIGJpdCBzbyB3ZSBkY2FjaGUgZmlsZSBhbmQKCQkvLyBkaXJlY3RvcnkgaW5vZGVzCgkJcHJp
bnRmKCJCZWZvcmUgbmV0IG5hbWVzcGFjZSBjaGFuZ2UgOlxuIik7CgkJZHVtcF9maWxlKCIvcHJv
Yy9uZXQvZGV2IiwgMCk7CgkJZHVtcF9kaXIoIi9wcm9jL25ldC9kZXZfc25tcDYiLCAwKTsKCX0g
ZWxzZSB7CgkJLy8gd2UgY2Fubm90IGNoZWNrIGZvciBidWcgaWYgbm90IHJ1biB3aXRoIGNhY2hl
ZCBhcmcKCQljaGVja2ZvcmJ1ZyA9IDA7Cgl9CgoJLy8gY2hhbmdlIG5hbWVzcGFjZQoJc3dpdGNo
X25zKCJuZXRuc19vdGhlciIpOwoKCS8vIGFjY2VzcyAvcHJvYy9uZXQgYWdhaW4sIGlmIGFsbCB3
b3JrcyB3ZSBzaG91bGQgc2VlCgkvLyBuZXcgaW5mbyBiZWNhdXNlIG9mIG5ldCBuYW1lc3BhY2Ug
Y2hhbmdlCglwcmludGYoIlxuXG5BZnRlciBuZXQgbmFtZXNwYWNlIGNoYW5nZSA6XG4iKTsKCWJ1
Z2NoZWNrICs9IGR1bXBfZmlsZSgiL3Byb2MvbmV0L2RldiIsIDEpOwoJYnVnY2hlY2sgKz0gZHVt
cF9kaXIoIi9wcm9jL25ldC9kZXZfc25tcDYiLCAxKTsKCglpZiAoIWNoZWNrZm9yYnVnKQoJCXJl
dHVybiAwOwoJCglzd2l0Y2ggKGJ1Z2NoZWNrKSB7CgkJY2FzZSAxIDoKCQkJcHJpbnRmKCJUaGlz
IGtlcm5lbCBpcyBmaXhlZCBmb3IgZmlsZSBpbm9kZSBidWcgYnV0IHN1ZmZlcnMgZGlyIGlub2Rl
IGJ1Z1xuIik7CgkJCWJyZWFrOwoJCWNhc2UgMyA6CgkJCXByaW50ZigiVGhpcyBrZXJuZWwgaXMg
Zml4ZWQgZm9yIGJvdGggZmlsZSBhbmQgZGlyIGlub2RlIGJ1Z1xuIik7CgkJCWJyZWFrOwoJCWRl
ZmF1bHQgOgoJCQlwcmludGYoIlRoaXMga2VybmVsIHN1ZmZlcnMgYm90aCBmaWxlIGFuZCBkaXIg
aW5vZGUgYnVnXG4iKTsKCX0KCglyZXR1cm4gYnVnY2hlY2sgIT0gMzsKfQo=

--_005_B7B4BB465792624BAF51F33077E99065DC5D7225ALAMBDcorpadwrs_
Content-Type: application/x-shellscript; name="netns_procfs_test.sh"
Content-Description: netns_procfs_test.sh
Content-Disposition: attachment; filename="netns_procfs_test.sh"; size=144;
	creation-date="Tue, 25 Jun 2019 10:28:48 GMT";
	modification-date="Tue, 25 Jun 2019 10:28:48 GMT"
Content-Transfer-Encoding: base64

aXAgbmV0bnMgYWRkIG5ldG5zX290aGVyCmlwIGxpbmsgYWRkIGlmX2RlZmF1bHQgdHlwZSB2ZXRo
IHBlZXIgbmFtZSBpZl9vdGhlcgppcCBsaW5rIHNldCBpZl9vdGhlciBuZXRucyBuZXRuc19vdGhl
cgoKLi9uZXRuc19wcm9jZnNfdGVzdCBjYWNoZWQK

--_005_B7B4BB465792624BAF51F33077E99065DC5D7225ALAMBDcorpadwrs_--
