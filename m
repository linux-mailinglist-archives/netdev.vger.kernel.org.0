Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C083CF23C
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 04:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbhGTCLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 22:11:38 -0400
Received: from out1.migadu.com ([91.121.223.63]:45829 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345227AbhGTCGf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 22:06:35 -0400
X-Greylist: delayed 74690 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jul 2021 22:06:32 EDT
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1626749223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KUM79Rs6eGHbKmAlgI2lLlSUWIN0mpmmWXHIcNcS7zI=;
        b=gTaqIAJI0CbVfMDJeqMpW+lRczileGp8zONPxdkcXQCkBxLzVJmckriwwoT8BeHNPgDjFb
        17oHP5NdPccpo2mrJvDF2Mxf958uaBqpqPM/AgPHtXxCBa689BgBZae9H6c7aqODLC26jT
        q1Z85nKY797W42mc9N6VcB2Py4NxbjI=
Date:   Tue, 20 Jul 2021 02:47:01 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <d56d920c4e55383f9ee34147b58a1f9b@linux.dev>
Subject: Re: [PATCH] netlink: Deal with ESRCH error in nlmsg_notify()
To:     "Yonghong Song" <yhs@fb.com>, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <0ada4233-6c9d-82f5-f33f-55805bfbe37d@fb.com>
References: <0ada4233-6c9d-82f5-f33f-55805bfbe37d@fb.com>
 <20210719051816.11762-1-yajun.deng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

July 19, 2021 10:47 PM, "Yonghong Song" <yhs@fb.com> wrote:=0A=0A> On 7/1=
8/21 10:18 PM, Yajun Deng wrote:=0A> =0A>> Yonghong Song report:=0A>> The=
 bpf selftest tc_bpf failed with latest bpf-next.=0A>> The following is t=
he command to run and the result:=0A>> $ ./test_progs -n 132=0A>> [ 40.94=
7571] bpf_testmod: loading out-of-tree module taints kernel.=0A>> test_tc=
_bpf:PASS:test_tc_bpf__open_and_load 0 nsec=0A>> test_tc_bpf:PASS:bpf_tc_=
hook_create(BPF_TC_INGRESS) 0 nsec=0A>> test_tc_bpf:PASS:bpf_tc_hook_crea=
te invalid hook.attach_point 0 nsec=0A>> test_tc_bpf_basic:PASS:bpf_obj_g=
et_info_by_fd 0 nsec=0A>> test_tc_bpf_basic:PASS:bpf_tc_attach 0 nsec=0A>=
> test_tc_bpf_basic:PASS:handle set 0 nsec=0A>> test_tc_bpf_basic:PASS:pr=
iority set 0 nsec=0A>> test_tc_bpf_basic:PASS:prog_id set 0 nsec=0A>> tes=
t_tc_bpf_basic:PASS:bpf_tc_attach replace mode 0 nsec=0A>> test_tc_bpf_ba=
sic:PASS:bpf_tc_query 0 nsec=0A>> test_tc_bpf_basic:PASS:handle set 0 nse=
c=0A>> test_tc_bpf_basic:PASS:priority set 0 nsec=0A>> test_tc_bpf_basic:=
PASS:prog_id set 0 nsec=0A>> libbpf: Kernel error message: Failed to send=
 filter delete notification=0A>> test_tc_bpf_basic:FAIL:bpf_tc_detach une=
xpected error: -3 (errno 3)=0A>> test_tc_bpf:FAIL:test_tc_internal ingres=
s unexpected error: -3 (errno 3)=0A>> The failure seems due to the commit=
=0A>> cfdf0d9ae75b ("rtnetlink: use nlmsg_notify() in rtnetlink_send()")=
=0A>> Deal with ESRCH error in nlmsg_notify() even the report variable is=
 zero.=0A>> Reported-by: Yonghong Song <yhs@fb.com>=0A>> Signed-off-by: Y=
ajun Deng <yajun.deng@linux.dev>=0A> =0A> Thanks for quick fix. This does=
 fix the bpf selftest issu.=0A> But does this change have negative impact=
s on other=0A> nlmsg_notify() callers, below 1-3 items?=0A> =0A> 0 net/co=
re/rtnetlink.c rtnetlink_send 714 return nlmsg_notify(rtnl, skb, pid, gro=
up, echo,=0A> GFP_KERNEL);=0A=0AThis is exactly what we need.=0A> =0A> 1 =
net/core/rtnetlink.c rtnl_notify 734 nlmsg_notify(rtnl, skb, pid, group, =
report, flags);=0A> =0AIt doesn't matter because there is no return value=
.=0A =0A> 2 net/netfilter/nfnetlink.c nfnetlink_send 176 return nlmsg_not=
ify(nfnlnet->nfnl, skb, portid,=0A> group, echo, flags);=0A> =0AIt only c=
tnetlink_conntrack_event() use the return value when call nfnetlink_send(=
) in=0Anet/netfilter/nf_conntrack_netlink.c, but it doesn't matter when t=
he return value is ESRCH or zero.=0A=0A> 3 net/netlink/genetlink.c genl_n=
otify 1506 nlmsg_notify(sk, skb, info->snd_portid, group, report,=0A> fla=
gs);=0A> =0AIt doesn't matter because there is no return value.=0A=0AI th=
ink the caller for nlmsg_notify() doesn't need deal with the ESRCH. It al=
so deal with ESRCH=0Awhen report variable is not zero.=0A=0A>> ---=0A>> n=
et/netlink/af_netlink.c | 4 +++-=0A>> 1 file changed, 3 insertions(+), 1 =
deletion(-)=0A>> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_n=
etlink.c=0A>> index 380f95aacdec..24b7cf447bc5 100644=0A>> --- a/net/netl=
ink/af_netlink.c=0A>> +++ b/net/netlink/af_netlink.c=0A>> @@ -2545,13 +25=
45,15 @@ int nlmsg_notify(struct sock *sk, struct sk_buff *skb, u32 porti=
d,=0A>> /* errors reported via destination sk->sk_err, but propagate=0A>>=
 * delivery errors if NETLINK_BROADCAST_ERROR flag is set */=0A>> err =3D=
 nlmsg_multicast(sk, skb, exclude_portid, group, flags);=0A>> + if (err =
=3D=3D -ESRCH)=0A>> + err =3D 0;=0A>> }=0A>>> if (report) {=0A>> int err2=
;=0A>>> err2 =3D nlmsg_unicast(sk, skb, portid);=0A>> - if (!err || err =
=3D=3D -ESRCH)=0A>> + if (!err)=0A>> err =3D err2;=0A>> }=0A>>>
