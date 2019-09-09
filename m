Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E707BADE2D
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 19:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391456AbfIIRqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 13:46:34 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:45298 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729123AbfIIRqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 13:46:33 -0400
Received: by mail-ua1-f68.google.com with SMTP id j6so4577581uae.12
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 10:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=o0/lvIPZd9AcVUvf4WG04U9KnuaGdZcRylxpRGBDKn4=;
        b=kHgxE905LPWJji2xrtLcWtqRij1AmfjcK3FHYpApXmk/DvNKG6GxjqrorJgklcCJm1
         qcNu/nneGtamnJBBCtGN6vFUk6NPXG9LsWBKx1FSqydWR6eW6Nwsr46KrAOyFoZGWUdD
         GGlKV26pz+WHmuIOBtMP2TCmp5gnxpjjNV8OQlR375I6D/U4t4QJZ9yXLkKWbVh8zMtF
         kAqzZF+9l6xaa9kVIVlvfEOWvrZwmbCXqId6kJok3YBw8MPF3ujfgnT661M2tLK3RW6z
         8lJsBQDpxUVpivsplVXEgr6NIg/fPO18J5iwjpy0G2uspz9vsehl7yA67Y4v7NVJUVmg
         JQUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=o0/lvIPZd9AcVUvf4WG04U9KnuaGdZcRylxpRGBDKn4=;
        b=Gn5vaxq/bkH6FYehSj0YduTKrYUnxZ2C86o2bZAeeJNk/Hsc5xvYfoxaCEUo5MLFys
         4OyB+Aq4steeCbn06nMQMaQhC5GJTN0KBXHz8WL+C77vbbup+8tTVOFpBmzUUsHjXVqc
         iEw/7UvZgPEl11uaXxjXTnO9ODgu3VeelvErL82NremxeF1zcKOFVcFrOikWG0QhzHE3
         SCrdjaRcwTZRcVGJfIBOn1xzvl22+siC8eP4/xTsIT25cv9HraR6eWs8Rjdk+OEmQylf
         rADtR4m7sCkkoHI06U2ZLj9lr/2eH4GBsh8s45vHgls1Ir7Wc09klW1mz+EUsNsgrsJ8
         GWuA==
X-Gm-Message-State: APjAAAVsjRWwWFs+W3FyLE00JVgPM8K/jQblsvi1JARAvUMqJ4xtKuKV
        Yu5ppXSTBdvzhYLw81kua3H0mi5hmF/fZnMhUp3MNPAv
X-Google-Smtp-Source: APXvYqxXYhTEwp6sqKofAKAqiKD24hKNIICZklVgAcdC+lAzBmvIz7Hg4DRdbDxMgif8BdU0X056PBu/BUA1e+g4VKY=
X-Received: by 2002:ab0:30ef:: with SMTP id d15mr10997094uam.135.1568051191596;
 Mon, 09 Sep 2019 10:46:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAOrEdsmpHT-=zH9zyHv=pLX2ENb1S0AnkrcWVgMxqWrxKsF3yw@mail.gmail.com>
 <CAOrEdsmxstWoBz2AotrTx_OBFN_jycqnSqtsvLxuCLGtKKi_dA@mail.gmail.com>
In-Reply-To: <CAOrEdsmxstWoBz2AotrTx_OBFN_jycqnSqtsvLxuCLGtKKi_dA@mail.gmail.com>
From:   Pooja Trivedi <poojatrivedi@gmail.com>
Date:   Mon, 9 Sep 2019 13:46:20 -0400
Message-ID: <CAOrEdsnNZ3GJTFzfcBhUv6wvnXTJf=b9eJ8Exk2CXR6VyLsn1Q@mail.gmail.com>
Subject: [PATCH net 0/1] net/tls(TLS_SW): double free in tls_tx_records
To:     netdev@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000043f10c0592225e0f"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000043f10c0592225e0f
Content-Type: text/plain; charset="UTF-8"

TLS module crash while running SSL record encryption using
klts_send_[file] using crypto accelerator (Nitrox).

Following are the preconditions and steps to reproduce the issue:

Preconditions:
1) Installed 5.3-rc4
2) Nitrox5 card plugin (crypto accelerator)

Steps to reproduce the issue:
1) Installed n5pf.ko (drivers/crypto/cavium/nitrox)
2) Installed tls.ko if not is installed by default (net/tls)
3) Obtained uperf tool from GitHub
   3.1) Modified uperf to use tls module by using setsocket.
   3.2) Modified uperf tool to support sendfile with SSL.

Test:
1) Ran uperf with 4 threads
2) Each thread sends data using sendfile over SSL protocol.

After a few seconds into the test, kernel crashes because of record
list corruption

[  270.888952] ------------[ cut here ]------------
[  270.890450] list_del corruption, ffff91cc3753a800->prev is
LIST_POISON2 (dead000000000122)
[  270.891194] WARNING: CPU: 1 PID: 7387 at lib/list_debug.c:50
__list_del_entry_valid+0x62/0x90
[  270.892037] Modules linked in: n5pf(OE) netconsole tls(OE) bonding
intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
aesni_intel crypto_simd mei_me cryptd glue_helper ipmi_si sg mei
lpc_ich pcspkr joydev ioatdma i2c_i801 ipmi_devintf ipmi_msghandler
wmi ip_tables xfs libcrc32c sd_mod mgag200 drm_vram_helper ttm
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm isci
libsas ahci scsi_transport_sas libahci crc32c_intel serio_raw igb
libata ptp pps_core dca i2c_algo_bit dm_mirror dm_region_hash dm_log
dm_mod [last unloaded: nitrox_drv]
[  270.896836] CPU: 1 PID: 7387 Comm: uperf Kdump: loaded Tainted: G
        OE     5.3.0-rc4 #1
[  270.897711] Hardware name: Supermicro SYS-1027R-N3RF/X9DRW, BIOS
3.0c 03/24/2014
[  270.898597] RIP: 0010:__list_del_entry_valid+0x62/0x90
[  270.899478] Code: 00 00 00 c3 48 89 fe 48 89 c2 48 c7 c7 e0 f9 ee
8d e8 b2 cf c8 ff 0f 0b 31 c0 c3 48 89 fe 48 c7 c7 18 fa ee 8d e8 9e
cf c8 ff <0f> 0b 31 c0 c3 48 89 f2 48 89 fe 48 c7 c7 50 fa ee 8d e8 87
cf c8
[  270.901321] RSP: 0018:ffffb6ea86eb7c20 EFLAGS: 00010282
[  270.902240] RAX: 0000000000000000 RBX: ffff91cc3753c000 RCX: 0000000000000000
[  270.903157] RDX: ffff91bc3f867080 RSI: ffff91bc3f857738 RDI: ffff91bc3f857738
[  270.904074] RBP: ffff91bc36020940 R08: 0000000000000560 R09: 0000000000000000
[  270.904988] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  270.905902] R13: ffff91cc3753a800 R14: ffff91cc37cc6400 R15: ffff91cc3753a800
[  270.906809] FS:  00007f454a88d700(0000) GS:ffff91bc3f840000(0000)
knlGS:0000000000000000
[  270.907715] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  270.908606] CR2: 00007f453c00292c CR3: 000000103554e003 CR4: 00000000001606e0
[  270.909490] Call Trace:
[  270.910373]  tls_tx_records+0x138/0x1c0 [tls]
[  270.911262]  tls_sw_sendpage+0x3e0/0x420 [tls]
[  270.912154]  inet_sendpage+0x52/0x90
[  270.913045]  ? direct_splice_actor+0x40/0x40
[  270.913941]  kernel_sendpage+0x1a/0x30
[  270.914831]  sock_sendpage+0x20/0x30
[  270.915714]  pipe_to_sendpage+0x62/0x90
[  270.916592]  __splice_from_pipe+0x80/0x180
[  270.917461]  ? direct_splice_actor+0x40/0x40
[  270.918334]  splice_from_pipe+0x5d/0x90
[  270.919208]  direct_splice_actor+0x35/0x40
[  270.920086]  splice_direct_to_actor+0x103/0x230
[  270.920966]  ? generic_pipe_buf_nosteal+0x10/0x10
[  270.921850]  do_splice_direct+0x9a/0xd0
[  270.922733]  do_sendfile+0x1c9/0x3d0
[  270.923612]  __x64_sys_sendfile64+0x5c/0xc0

Observations:
1) This issue is observed after applying "Commit a42055e8d2c3: Add
support for async encryption of records for performance"
2) 5.2.2 kernel exhibits the same issue

Attached is the complete crash log.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204669

linux-crypto original post:
https://marc.info/?l=linux-crypto-vger&m=156700690108854&w=2


After adding custom profiling around lock_sock/release_sock as well as
getting backtraces of the call stack at and around the time of the
crash/race-condition, it seems like using the socket lock is not the
best way to synchronize write access to tls_tx_records, especially
when the socket lock can get released under tcp memory pressure situation.

One potential way for race condition to appear:

When under tcp memory pressure, Thread 1 takes the following code path:
do_sendfile ---> ... ---> .... ---> tls_sw_sendpage --->
tls_sw_do_sendpage ---> tls_tx_records ---> tls_push_sg --->
do_tcp_sendpages ---> sk_stream_wait_memory ---> sk_wait_event

sk_wait_event releases the socket lock and sleeps waiting for memory:

#define sk_wait_event(__sk, __timeo, __condition, __wait)       \
     ({  int __rc;                       \
         release_sock(__sk);                 \
         __rc = __condition;                 \
         if (!__rc) {                        \
             *(__timeo) = wait_woken(__wait,         \
                         TASK_INTERRUPTIBLE, \
                         *(__timeo));        \
         }                           \
         sched_annotate_sleep();                 \
         lock_sock(__sk);                    \
         __rc = __condition;                 \
         __rc;                           \
     })

Thread 2 code path:
tx_work_handler ---> tls_tx_records

Thread 2 is able to obtain the socket lock and go through the
transmission of the ctx->tx_list, deleting the sent ones (as in the
for loop below).

int tls_tx_records(struct sock *sk, int flags)
{
     ....
     ....
     ....
     ....
     list_for_each_entry_safe(rec, tmp, &ctx->tx_list, list) {
          if (READ_ONCE(rec->tx_ready)) {
              if (flags == -1)
                  tx_flags = rec->tx_flags;
              else
                  tx_flags = flags;

              msg_en = &rec->msg_encrypted;
              rc = tls_push_sg(sk, tls_ctx,
                       &msg_en->sg.data[msg_en->sg.curr],
                       0, tx_flags);
              if (rc)
                  goto tx_err;

              list_del(&rec->list); // **** crash location ****
              sk_msg_free(sk, &rec->msg_plaintext);
              kfree(rec);
          } else {
              break;
          }
      }
     ....
     ....
     ....
     ....
}

When Thread 1 wakes up from tls_push_sg call and attempts list_del on
previously grabbed record which was sent and deleted by Thread 2, it
causes the crash.


To fix this race, a flag or bool inside of ctx can be used to
synchronize access to tls_tx_records.

--00000000000043f10c0592225e0f
Content-Type: text/plain; charset="US-ASCII"; name="tls_crash_log_5_3_rc4.txt"
Content-Disposition: attachment; filename="tls_crash_log_5_3_rc4.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_k0cneg9t0>
X-Attachment-Id: f_k0cneg9t0

WyAgMjcwLjg4ODk1Ml0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgIDI3
MC44OTA0NTBdIGxpc3RfZGVsIGNvcnJ1cHRpb24sIGZmZmY5MWNjMzc1M2E4MDAtPnByZXYgaXMg
TElTVF9QT0lTT04yIChkZWFkMDAwMDAwMDAwMTIyKQpbICAyNzAuODkxMTk0XSBXQVJOSU5HOiBD
UFU6IDEgUElEOiA3Mzg3IGF0IGxpYi9saXN0X2RlYnVnLmM6NTAgX19saXN0X2RlbF9lbnRyeV92
YWxpZCsweDYyLzB4OTAKWyAgMjcwLjg5MjAzN10gTW9kdWxlcyBsaW5rZWQgaW46IG41cGYoT0Up
IG5ldGNvbnNvbGUgdGxzKE9FKSBib25kaW5nIGludGVsX3JhcGxfbXNyIGludGVsX3JhcGxfY29t
bW9uIHNiX2VkYWMgeDg2X3BrZ190ZW1wX3RoZXJtYWwgaW50ZWxfcG93ZXJjbGFtcCBjb3JldGVt
cCBrdm1faW50ZWwga3ZtIGlUQ09fd2R0IGlUQ09fdmVuZG9yX3N1cHBvcnQgaXJxYnlwYXNzIGNy
Y3QxMGRpZl9wY2xtdWwgY3JjMzJfcGNsbXVsIGdoYXNoX2NsbXVsbmlfaW50ZWwgYWVzbmlfaW50
ZWwgY3J5cHRvX3NpbWQgbWVpX21lIGNyeXB0ZCBnbHVlX2hlbHBlciBpcG1pX3NpIHNnIG1laSBs
cGNfaWNoIHBjc3BrciBqb3lkZXYgaW9hdGRtYSBpMmNfaTgwMSBpcG1pX2RldmludGYgaXBtaV9t
c2doYW5kbGVyIHdtaSBpcF90YWJsZXMgeGZzIGxpYmNyYzMyYyBzZF9tb2QgbWdhZzIwMCBkcm1f
dnJhbV9oZWxwZXIgdHRtIGRybV9rbXNfaGVscGVyIHN5c2NvcHlhcmVhIHN5c2ZpbGxyZWN0IHN5
c2ltZ2JsdCBmYl9zeXNfZm9wcyBkcm0gaXNjaSBsaWJzYXMgYWhjaSBzY3NpX3RyYW5zcG9ydF9z
YXMgbGliYWhjaSBjcmMzMmNfaW50ZWwgc2VyaW9fcmF3IGlnYiBsaWJhdGEgcHRwIHBwc19jb3Jl
IGRjYSBpMmNfYWxnb19iaXQgZG1fbWlycm9yIGRtX3JlZ2lvbl9oYXNoIGRtX2xvZyBkbV9tb2Qg
W2xhc3QgdW5sb2FkZWQ6IG5pdHJveF9kcnZdClsgIDI3MC44OTY4MzZdIENQVTogMSBQSUQ6IDcz
ODcgQ29tbTogdXBlcmYgS2R1bXA6IGxvYWRlZCBUYWludGVkOiBHICAgICAgICAgICBPRSAgICAg
NS4zLjAtcmM0ICMxClsgIDI3MC44OTc3MTFdIEhhcmR3YXJlIG5hbWU6IFN1cGVybWljcm8gU1lT
LTEwMjdSLU4zUkYvWDlEUlcsIEJJT1MgMy4wYyAwMy8yNC8yMDE0ClsgIDI3MC44OTg1OTddIFJJ
UDogMDAxMDpfX2xpc3RfZGVsX2VudHJ5X3ZhbGlkKzB4NjIvMHg5MApbICAyNzAuODk5NDc4XSBD
b2RlOiAwMCAwMCAwMCBjMyA0OCA4OSBmZSA0OCA4OSBjMiA0OCBjNyBjNyBlMCBmOSBlZSA4ZCBl
OCBiMiBjZiBjOCBmZiAwZiAwYiAzMSBjMCBjMyA0OCA4OSBmZSA0OCBjNyBjNyAxOCBmYSBlZSA4
ZCBlOCA5ZSBjZiBjOCBmZiA8MGY+IDBiIDMxIGMwIGMzIDQ4IDg5IGYyIDQ4IDg5IGZlIDQ4IGM3
IGM3IDUwIGZhIGVlIDhkIGU4IDg3IGNmIGM4ClsgIDI3MC45MDEzMjFdIFJTUDogMDAxODpmZmZm
YjZlYTg2ZWI3YzIwIEVGTEFHUzogMDAwMTAyODIKWyAgMjcwLjkwMjI0MF0gUkFYOiAwMDAwMDAw
MDAwMDAwMDAwIFJCWDogZmZmZjkxY2MzNzUzYzAwMCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDAKWyAg
MjcwLjkwMzE1N10gUkRYOiBmZmZmOTFiYzNmODY3MDgwIFJTSTogZmZmZjkxYmMzZjg1NzczOCBS
REk6IGZmZmY5MWJjM2Y4NTc3MzgKWyAgMjcwLjkwNDA3NF0gUkJQOiBmZmZmOTFiYzM2MDIwOTQw
IFIwODogMDAwMDAwMDAwMDAwMDU2MCBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKWyAgMjcwLjkwNDk4
OF0gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDAwMCBSMTI6IDAwMDAw
MDAwMDAwMDAwMDAKWyAgMjcwLjkwNTkwMl0gUjEzOiBmZmZmOTFjYzM3NTNhODAwIFIxNDogZmZm
ZjkxY2MzN2NjNjQwMCBSMTU6IGZmZmY5MWNjMzc1M2E4MDAKWyAgMjcwLjkwNjgwOV0gRlM6ICAw
MDAwN2Y0NTRhODhkNzAwKDAwMDApIEdTOmZmZmY5MWJjM2Y4NDAwMDAoMDAwMCkga25sR1M6MDAw
MDAwMDAwMDAwMDAwMApbICAyNzAuOTA3NzE1XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAg
Q1IwOiAwMDAwMDAwMDgwMDUwMDMzClsgIDI3MC45MDg2MDZdIENSMjogMDAwMDdmNDUzYzAwMjky
YyBDUjM6IDAwMDAwMDEwMzU1NGUwMDMgQ1I0OiAwMDAwMDAwMDAwMTYwNmUwClsgIDI3MC45MDk0
OTBdIENhbGwgVHJhY2U6ClsgIDI3MC45MTAzNzNdICB0bHNfdHhfcmVjb3JkcysweDEzOC8weDFj
MCBbdGxzXQpbICAyNzAuOTExMjYyXSAgdGxzX3N3X3NlbmRwYWdlKzB4M2UwLzB4NDIwIFt0bHNd
ClsgIDI3MC45MTIxNTRdICBpbmV0X3NlbmRwYWdlKzB4NTIvMHg5MApbICAyNzAuOTEzMDQ1XSAg
PyBkaXJlY3Rfc3BsaWNlX2FjdG9yKzB4NDAvMHg0MApbICAyNzAuOTEzOTQxXSAga2VybmVsX3Nl
bmRwYWdlKzB4MWEvMHgzMApbICAyNzAuOTE0ODMxXSAgc29ja19zZW5kcGFnZSsweDIwLzB4MzAK
WyAgMjcwLjkxNTcxNF0gIHBpcGVfdG9fc2VuZHBhZ2UrMHg2Mi8weDkwClsgIDI3MC45MTY1OTJd
ICBfX3NwbGljZV9mcm9tX3BpcGUrMHg4MC8weDE4MApbICAyNzAuOTE3NDYxXSAgPyBkaXJlY3Rf
c3BsaWNlX2FjdG9yKzB4NDAvMHg0MApbICAyNzAuOTE4MzM0XSAgc3BsaWNlX2Zyb21fcGlwZSsw
eDVkLzB4OTAKWyAgMjcwLjkxOTIwOF0gIGRpcmVjdF9zcGxpY2VfYWN0b3IrMHgzNS8weDQwClsg
IDI3MC45MjAwODZdICBzcGxpY2VfZGlyZWN0X3RvX2FjdG9yKzB4MTAzLzB4MjMwClsgIDI3MC45
MjA5NjZdICA/IGdlbmVyaWNfcGlwZV9idWZfbm9zdGVhbCsweDEwLzB4MTAKWyAgMjcwLjkyMTg1
MF0gIGRvX3NwbGljZV9kaXJlY3QrMHg5YS8weGQwClsgIDI3MC45MjI3MzNdICBkb19zZW5kZmls
ZSsweDFjOS8weDNkMApbICAyNzAuOTIzNjEyXSAgX194NjRfc3lzX3NlbmRmaWxlNjQrMHg1Yy8w
eGMwClsgIDI3MC45MjQ0ODVdICBkb19zeXNjYWxsXzY0KzB4NWIvMHgxZDAKWyAgMjcwLjkyNTM0
NF0gIGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFtZSsweDQ0LzB4YTkKWyAgMjcwLjkyNjE4
OF0gUklQOiAwMDMzOjB4N2Y0NTRjOWJmNmJhClsgIDI3MC45MjcwMTBdIENvZGU6IDMxIGMwIDVi
IGMzIDBmIDFmIDQwIDAwIDQ4IDg5IGRhIDRjIDg5IGNlIDQ0IDg5IGM3IDViIGU5IDA5IGZlIGZm
IGZmIDY2IDBmIDFmIDg0IDAwIDAwIDAwIDAwIDAwIDQ5IDg5IGNhIGI4IDI4IDAwIDAwIDAwIDBm
IDA1IDw0OD4gM2QgMDEgZjAgZmYgZmYgNzMgMDEgYzMgNDggOGIgMGQgODYgMjcgMmQgMDAgZjcg
ZDggNjQgODkgMDEgNDgKWyAgMjcwLjkyODcxMF0gUlNQOiAwMDJiOjAwMDA3ZjQ1NGE4OGNkMDgg
RUZMQUdTOiAwMDAwMDI0NiBPUklHX1JBWDogMDAwMDAwMDAwMDAwMDAyOApbICAyNzAuOTI5NTcz
XSBSQVg6IGZmZmZmZmZmZmZmZmZmZGEgUkJYOiAwMDAwMDAwMDAyMDI1NDYwIFJDWDogMDAwMDdm
NDU0YzliZjZiYQpbICAyNzAuOTMwNDMzXSBSRFg6IDAwMDA3ZjQ1NGE4OGNkMTggUlNJOiAwMDAw
MDAwMDAwMDAwMDA1IFJESTogMDAwMDAwMDAwMDAwMDAwYQpbICAyNzAuOTMxMjk0XSBSQlA6IDAw
MDAwMDAwMDAwMDAwMGEgUjA4OiAwMDAwN2Y0NTRjYzkyMGVjIFIwOTogMDAwMDdmNDU0Y2M5MjE0
MApbICAyNzAuOTMyMTQ2XSBSMTA6IDAwMDAwMDAwMDAwMDEwMDAgUjExOiAwMDAwMDAwMDAwMDAw
MjQ2IFIxMjogMDAwMDAwMDAwMDAwMDAwMApbICAyNzAuOTMyOTg4XSBSMTM6IDAwMDAwMDAwMDAw
MDAwMDAgUjE0OiAwMDAwMDAwMDAwMDAwMDAwIFIxNTogMDAwMDAwMDAwMjAzMDc4OApbICAyNzAu
OTMzODA5XSAtLS1bIGVuZCB0cmFjZSA0ZWU3MDgwMmU4NDdhOWRlIF0tLS0KWyAgMjcwLjkzNDYy
NF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgIDI3MC45MzU5NTddIGxp
c3RfZGVsIGNvcnJ1cHRpb24sIGZmZmY5MWNjMzc1M2MwMDAtPnByZXYgaXMgTElTVF9QT0lTT04y
IChkZWFkMDAwMDAwMDAwMTIyKQpbICAyNzAuOTM3MzgxXSBXQVJOSU5HOiBDUFU6IDEgUElEOiA3
Mzg3IGF0IGxpYi9saXN0X2RlYnVnLmM6NTAgX19saXN0X2RlbF9lbnRyeV92YWxpZCsweDYyLzB4
OTAKWyAgMjcwLjkzODM4NF0gTW9kdWxlcyBsaW5rZWQgaW46IG41cGYoT0UpIG5ldGNvbnNvbGUg
dGxzKE9FKSBib25kaW5nIGludGVsX3JhcGxfbXNyIGludGVsX3JhcGxfY29tbW9uIHNiX2VkYWMg
eDg2X3BrZ190ZW1wX3RoZXJtYWwgaW50ZWxfcG93ZXJjbGFtcCBjb3JldGVtcCBrdm1faW50ZWwg
a3ZtIGlUQ09fd2R0IGlUQ09fdmVuZG9yX3N1cHBvcnQgaXJxYnlwYXNzIGNyY3QxMGRpZl9wY2xt
dWwgY3JjMzJfcGNsbXVsIGdoYXNoX2NsbXVsbmlfaW50ZWwgYWVzbmlfaW50ZWwgY3J5cHRvX3Np
bWQgbWVpX21lIGNyeXB0ZCBnbHVlX2hlbHBlciBpcG1pX3NpIHNnIG1laSBscGNfaWNoIHBjc3Br
ciBqb3lkZXYgaW9hdGRtYSBpMmNfaTgwMSBpcG1pX2RldmludGYgaXBtaV9tc2doYW5kbGVyIHdt
aSBpcF90YWJsZXMgeGZzIGxpYmNyYzMyYyBzZF9tb2QgbWdhZzIwMCBkcm1fdnJhbV9oZWxwZXIg
dHRtIGRybV9rbXNfaGVscGVyIHN5c2NvcHlhcmVhIHN5c2ZpbGxyZWN0IHN5c2ltZ2JsdCBmYl9z
eXNfZm9wcyBkcm0gaXNjaSBsaWJzYXMgYWhjaSBzY3NpX3RyYW5zcG9ydF9zYXMgbGliYWhjaSBj
cmMzMmNfaW50ZWwgc2VyaW9fcmF3IGlnYiBsaWJhdGEgcHRwIHBwc19jb3JlIGRjYSBpMmNfYWxn
b19iaXQgZG1fbWlycm9yIGRtX3JlZ2lvbl9oYXNoIGRtX2xvZyBkbV9tb2QgW2xhc3QgdW5sb2Fk
ZWQ6IG5pdHJveF9kcnZdClsgIDI3MC45NDMxMTldIENQVTogMSBQSUQ6IDczODcgQ29tbTogdXBl
cmYgS2R1bXA6IGxvYWRlZCBUYWludGVkOiBHICAgICAgICBXICBPRSAgICAgNS4zLjAtcmM0ICMx
ClsgIDI3MC45NDM5MjBdIEhhcmR3YXJlIG5hbWU6IFN1cGVybWljcm8gU1lTLTEwMjdSLU4zUkYv
WDlEUlcsIEJJT1MgMy4wYyAwMy8yNC8yMDE0ClsgIDI3MC45NDQ3MjVdIFJJUDogMDAxMDpfX2xp
c3RfZGVsX2VudHJ5X3ZhbGlkKzB4NjIvMHg5MApbICAyNzAuOTQ1NTIyXSBDb2RlOiAwMCAwMCAw
MCBjMyA0OCA4OSBmZSA0OCA4OSBjMiA0OCBjNyBjNyBlMCBmOSBlZSA4ZCBlOCBiMiBjZiBjOCBm
ZiAwZiAwYiAzMSBjMCBjMyA0OCA4OSBmZSA0OCBjNyBjNyAxOCBmYSBlZSA4ZCBlOCA5ZSBjZiBj
OCBmZiA8MGY+IDBiIDMxIGMwIGMzIDQ4IDg5IGYyIDQ4IDg5IGZlIDQ4IGM3IGM3IDUwIGZhIGVl
IDhkIGU4IDg3IGNmIGM4ClsgIDI3MC45NDcxOTNdIFJTUDogMDAxODpmZmZmYjZlYTg2ZWI3YzIw
IEVGTEFHUzogMDAwMTAyODIKWyAgMjcwLjk0ODAzN10gUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJC
WDogZmZmZjkxY2MzNzUzYTgwMCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDAKWyAgMjcwLjk0ODg4Ml0g
UkRYOiBmZmZmOTFiYzNmODY3MDgwIFJTSTogZmZmZjkxYmMzZjg1NzczOCBSREk6IGZmZmY5MWJj
M2Y4NTc3MzgKWyAgMjcwLjk0OTcyM10gUkJQOiBmZmZmOTFiYzM2MDIwOTQwIFIwODogMDAwMDAw
MDAwMDAwMDU4ZCBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKWyAgMjcwLjk1MDU2Ml0gUjEwOiAwMDAw
MDAwMDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDAwMCBSMTI6IDAwMDAwMDAwMDAwMDAwMDAK
WyAgMjcwLjk1MTM4N10gUjEzOiBmZmZmOTFjYzM3NTNjMDAwIFIxNDogZmZmZjkxY2MzN2NjNjQw
MCBSMTU6IGZmZmY5MWNjMzc1M2MwMDAKWyAgMjcwLjk1MjIyMF0gRlM6ICAwMDAwN2Y0NTRhODhk
NzAwKDAwMDApIEdTOmZmZmY5MWJjM2Y4NDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAw
MApbICAyNzAuOTUzMDY1XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAw
MDgwMDUwMDMzClsgIDI3MC45NTM5MTRdIENSMjogMDAwMDdmNDUzYzAwMjkyYyBDUjM6IDAwMDAw
MDEwMzU1NGUwMDMgQ1I0OiAwMDAwMDAwMDAwMTYwNmUwClsgIDI3MC45NTQ3NzddIENhbGwgVHJh
Y2U6ClsgIDI3MC45NTU2MzZdICB0bHNfdHhfcmVjb3JkcysweDEzOC8weDFjMCBbdGxzXQpbICAy
NzAuOTU2NDk5XSAgdGxzX3N3X3NlbmRwYWdlKzB4M2UwLzB4NDIwIFt0bHNdClsgIDI3MC45NTcz
NjZdICBpbmV0X3NlbmRwYWdlKzB4NTIvMHg5MApbICAyNzAuOTU4MjMyXSAgPyBkaXJlY3Rfc3Bs
aWNlX2FjdG9yKzB4NDAvMHg0MApbICAyNzAuOTU5MTAxXSAga2VybmVsX3NlbmRwYWdlKzB4MWEv
MHgzMApbICAyNzAuOTU5OTY3XSAgc29ja19zZW5kcGFnZSsweDIwLzB4MzAKWyAgMjcwLjk2MDgz
MF0gIHBpcGVfdG9fc2VuZHBhZ2UrMHg2Mi8weDkwClsgIDI3MC45NjE2OTNdICBfX3NwbGljZV9m
cm9tX3BpcGUrMHg4MC8weDE4MApbICAyNzAuOTYyNTU2XSAgPyBkaXJlY3Rfc3BsaWNlX2FjdG9y
KzB4NDAvMHg0MApbICAyNzAuOTYzNDEzXSAgc3BsaWNlX2Zyb21fcGlwZSsweDVkLzB4OTAKWyAg
MjcwLjk2NDI3NF0gIGRpcmVjdF9zcGxpY2VfYWN0b3IrMHgzNS8weDQwClsgIDI3MC45NjUxMzZd
ICBzcGxpY2VfZGlyZWN0X3RvX2FjdG9yKzB4MTAzLzB4MjMwClsgIDI3MC45NjYwMDFdICA/IGdl
bmVyaWNfcGlwZV9idWZfbm9zdGVhbCsweDEwLzB4MTAKWyAgMjcwLjk2Njg2N10gIGRvX3NwbGlj
ZV9kaXJlY3QrMHg5YS8weGQwClsgIDI3MC45Njc3MjddICBkb19zZW5kZmlsZSsweDFjOS8weDNk
MApbICAyNzAuOTY4NTY1XSAgX194NjRfc3lzX3NlbmRmaWxlNjQrMHg1Yy8weGMwClsgIDI3MC45
NjkzODBdICBkb19zeXNjYWxsXzY0KzB4NWIvMHgxZDAKWyAgMjcwLjk3MDE4NV0gIGVudHJ5X1NZ
U0NBTExfNjRfYWZ0ZXJfaHdmcmFtZSsweDQ0LzB4YTkKWyAgMjcwLjk3MDk4NV0gUklQOiAwMDMz
OjB4N2Y0NTRjOWJmNmJhClsgIDI3MC45NzE3NzhdIENvZGU6IDMxIGMwIDViIGMzIDBmIDFmIDQw
IDAwIDQ4IDg5IGRhIDRjIDg5IGNlIDQ0IDg5IGM3IDViIGU5IDA5IGZlIGZmIGZmIDY2IDBmIDFm
IDg0IDAwIDAwIDAwIDAwIDAwIDQ5IDg5IGNhIGI4IDI4IDAwIDAwIDAwIDBmIDA1IDw0OD4gM2Qg
MDEgZjAgZmYgZmYgNzMgMDEgYzMgNDggOGIgMGQgODYgMjcgMmQgMDAgZjcgZDggNjQgODkgMDEg
NDgKWyAgMjcwLjk3MzQzOF0gUlNQOiAwMDJiOjAwMDA3ZjQ1NGE4OGNkMDggRUZMQUdTOiAwMDAw
MDI0NiBPUklHX1JBWDogMDAwMDAwMDAwMDAwMDAyOApbICAyNzAuOTc0MjkzXSBSQVg6IGZmZmZm
ZmZmZmZmZmZmZGEgUkJYOiAwMDAwMDAwMDAyMDI1NDYwIFJDWDogMDAwMDdmNDU0YzliZjZiYQpb
ICAyNzAuOTc1MTQ4XSBSRFg6IDAwMDA3ZjQ1NGE4OGNkMTggUlNJOiAwMDAwMDAwMDAwMDAwMDA1
IFJESTogMDAwMDAwMDAwMDAwMDAwYQpbICAyNzAuOTc2MDA5XSBSQlA6IDAwMDAwMDAwMDAwMDAw
MGEgUjA4OiAwMDAwN2Y0NTRjYzkyMGVjIFIwOTogMDAwMDdmNDU0Y2M5MjE0MApbICAyNzAuOTc2
ODYwXSBSMTA6IDAwMDAwMDAwMDAwMDEwMDAgUjExOiAwMDAwMDAwMDAwMDAwMjQ2IFIxMjogMDAw
MDAwMDAwMDAwMDAwMApbICAyNzAuOTc3Njk5XSBSMTM6IDAwMDAwMDAwMDAwMDAwMDAgUjE0OiAw
MDAwMDAwMDAwMDAwMDAwIFIxNTogMDAwMDAwMDAwMjAzMDc4OApbICAyNzAuOTc4NTE0XSAtLS1b
IGVuZCB0cmFjZSA0ZWU3MDgwMmU4NDdhOWRmIF0tLS0KWyAgMjcwLjk3OTMzMF0gQlVHOiB1bmFi
bGUgdG8gaGFuZGxlIHBhZ2UgZmF1bHQgZm9yIGFkZHJlc3M6IGZmZmY5MWQzODNlMDU3ODQKWyAg
MjcwLjk4MDc0OV0gI1BGOiBzdXBlcnZpc29yIHJlYWQgYWNjZXNzIGluIGtlcm5lbCBtb2RlClsg
IDI3MC45ODE4MjBdICNQRjogZXJyb3JfY29kZSgweDAwMDApIC0gbm90LXByZXNlbnQgcGFnZQpb
ICAyNzAuOTgyNTcxXSBQR0QgMTAzMmUwMTA2NyBQNEQgMTAzMmUwMTA2NyBQVUQgMCAKWyAgMjcw
Ljk4MzMwM10gT29wczogMDAwMCBbIzFdIFNNUCBQVEkKWyAgMjcwLjk4NDAyMF0gQ1BVOiAxIFBJ
RDogNzM4NyBDb21tOiB1cGVyZiBLZHVtcDogbG9hZGVkIFRhaW50ZWQ6IEcgICAgICAgIFcgIE9F
ICAgICA1LjMuMC1yYzQgIzEKWyAgMjcwLjk4NDc0OF0gSGFyZHdhcmUgbmFtZTogU3VwZXJtaWNy
byBTWVMtMTAyN1ItTjNSRi9YOURSVywgQklPUyAzLjBjIDAzLzI0LzIwMTQKWyAgMjcwLjk4NTQ3
M10gUklQOiAwMDEwOnRsc19wdXNoX3NnKzB4MjcvMHgxOTAgW3Rsc10KWyAgMjcwLjk4NjE4NF0g
Q29kZTogMDAgMDAgMDAgMGYgMWYgNDQgMDAgMDAgNDEgNTcgNDQgMGYgYjcgZDEgNDEgNTYgNDEg
NTUgNDkgODkgZDUgNDEgNTQgNDUgODkgYzQgNDEgODEgY2MgMDAgMDAgMDIgMDAgNTUgNDggODkg
ZmQgNTMgNDggODMgZWMgMTAgPDQ0PiA4YiA0YSAwYyA0OCA4OSA3NCAyNCAwOCA0NCA4OSA0NCAy
NCAwNCA0NSA4OSBjZSA0NSAyOSBkNiA0NCAwMwpbICAyNzAuOTg3NjMxXSBSU1A6IDAwMTg6ZmZm
ZmI2ZWE4NmViN2JlMCBFRkxBR1M6IDAwMDEwMjgyClsgIDI3MC45ODgzNTBdIFJBWDogMDAwMDAw
MDc0YzhjYWNhMCBSQlg6IGZmZmY5MWNjMzc1M2I4MDAgUkNYOiAwMDAwMDAwMDAwMDAwMDAwClsg
IDI3MC45ODkwODFdIFJEWDogZmZmZjkxZDM4M2UwNTc3OCBSU0k6IGZmZmY5MWNjMzdjYzY0MDAg
UkRJOiBmZmZmOTFiYzM2MDIwOTQwClsgIDI3MC45ODk4MTNdIFJCUDogZmZmZjkxYmMzNjAyMDk0
MCBSMDg6IDAwMDAwMDAwMDAwMDAwMDAgUjA5OiAwMDAwMDAwMDAwMDAwMDAwClsgIDI3MC45OTA1
NDhdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDAwMDAwMDAwMDAwMDAgUjEyOiAwMDAw
MDAwMDAwMDIwMDAwClsgIDI3MC45OTEyNzJdIFIxMzogZmZmZjkxZDM4M2UwNTc3OCBSMTQ6IGZm
ZmY5MWNjMzdjYzY0MDAgUjE1OiBmZmZmOTFjYzM3NTNhODAwClsgIDI3MC45OTE5OTldIEZTOiAg
MDAwMDdmNDU0YTg4ZDcwMCgwMDAwKSBHUzpmZmZmOTFiYzNmODQwMDAwKDAwMDApIGtubEdTOjAw
MDAwMDAwMDAwMDAwMDAKWyAgMjcwLjk5MjcyN10gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAw
IENSMDogMDAwMDAwMDA4MDA1MDAzMwpbICAyNzAuOTkzNDQ4XSBDUjI6IGZmZmY5MWQzODNlMDU3
ODQgQ1IzOiAwMDAwMDAxMDM1NTRlMDAzIENSNDogMDAwMDAwMDAwMDE2MDZlMApbICAyNzAuOTk0
MTc3XSBDYWxsIFRyYWNlOgpbICAyNzAuOTk0OTA1XSAgdGxzX3R4X3JlY29yZHMrMHgxMjgvMHgx
YzAgW3Rsc10KWyAgMjcwLjk5NTYzOF0gIHRsc19zd19zZW5kcGFnZSsweDNlMC8weDQyMCBbdGxz
XQpbICAyNzAuOTk2MzY1XSAgaW5ldF9zZW5kcGFnZSsweDUyLzB4OTAKWyAgMjcwLjk5NzA5NV0g
ID8gZGlyZWN0X3NwbGljZV9hY3RvcisweDQwLzB4NDAKWyAgMjcwLjk5NzgyNl0gIGtlcm5lbF9z
ZW5kcGFnZSsweDFhLzB4MzAKWyAgMjcwLjk5ODU1NV0gIHNvY2tfc2VuZHBhZ2UrMHgyMC8weDMw
ClsgIDI3MC45OTkyODFdICBwaXBlX3RvX3NlbmRwYWdlKzB4NjIvMHg5MApbICAyNzEuMDAwMDEw
XSAgX19zcGxpY2VfZnJvbV9waXBlKzB4ODAvMHgxODAKWyAgMjcxLjAwMDc0MF0gID8gZGlyZWN0
X3NwbGljZV9hY3RvcisweDQwLzB4NDAKWyAgMjcxLjAwMTQ2N10gIHNwbGljZV9mcm9tX3BpcGUr
MHg1ZC8weDkwClsgIDI3MS4wMDIxOTldICBkaXJlY3Rfc3BsaWNlX2FjdG9yKzB4MzUvMHg0MApb
ICAyNzEuMDAyOTMwXSAgc3BsaWNlX2RpcmVjdF90b19hY3RvcisweDEwMy8weDIzMApbICAyNzEu
MDAzNjYxXSAgPyBnZW5lcmljX3BpcGVfYnVmX25vc3RlYWwrMHgxMC8weDEwClsgIDI3MS4wMDQz
ODddICBkb19zcGxpY2VfZGlyZWN0KzB4OWEvMHhkMApbICAyNzEuMDA1MTE4XSAgZG9fc2VuZGZp
bGUrMHgxYzkvMHgzZDAKWyAgMjcxLjAwNTg0OV0gIF9feDY0X3N5c19zZW5kZmlsZTY0KzB4NWMv
MHhjMApbICAyNzEuMDA2NTc5XSAgZG9fc3lzY2FsbF82NCsweDViLzB4MWQwClsgIDI3MS4wMDcz
MDFdICBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg0NC8weGE5ClsgIDI3MS4wMDgw
MzFdIFJJUDogMDAzMzoweDdmNDU0YzliZjZiYQpbICAyNzEuMDA4NzM3XSBDb2RlOiAzMSBjMCA1
YiBjMyAwZiAxZiA0MCAwMCA0OCA4OSBkYSA0YyA4OSBjZSA0NCA4OSBjNyA1YiBlOSAwOSBmZSBm
ZiBmZiA2NiAwZiAxZiA4NCAwMCAwMCAwMCAwMCAwMCA0OSA4OSBjYSBiOCAyOCAwMCAwMCAwMCAw
ZiAwNSA8NDg+IDNkIDAxIGYwIGZmIGZmIDczIDAxIGMzIDQ4IDhiIDBkIDg2IDI3IDJkIDAwIGY3
IGQ4IDY0IDg5IDAxIDQ4ClsgIDI3MS4wMTAxODddIFJTUDogMDAyYjowMDAwN2Y0NTRhODhjZDA4
IEVGTEFHUzogMDAwMDAyNDYgT1JJR19SQVg6IDAwMDAwMDAwMDAwMDAwMjgKWyAgMjcxLjAxMDkx
NV0gUkFYOiBmZmZmZmZmZmZmZmZmZmRhIFJCWDogMDAwMDAwMDAwMjAyNTQ2MCBSQ1g6IDAwMDA3
ZjQ1NGM5YmY2YmEKWyAgMjcxLjAxMTY0OF0gUkRYOiAwMDAwN2Y0NTRhODhjZDE4IFJTSTogMDAw
MDAwMDAwMDAwMDAwNSBSREk6IDAwMDAwMDAwMDAwMDAwMGEKWyAgMjcxLjAxMjM3NF0gUkJQOiAw
MDAwMDAwMDAwMDAwMDBhIFIwODogMDAwMDdmNDU0Y2M5MjBlYyBSMDk6IDAwMDA3ZjQ1NGNjOTIx
NDAKWyAgMjcxLjAxMzEwOV0gUjEwOiAwMDAwMDAwMDAwMDAxMDAwIFIxMTogMDAwMDAwMDAwMDAw
MDI0NiBSMTI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgMjcxLjAxMzg0OF0gUjEzOiAwMDAwMDAwMDAw
MDAwMDAwIFIxNDogMDAwMDAwMDAwMDAwMDAwMCBSMTU6IDAwMDAwMDAwMDIwMzA3ODgKWyAgMjcx
LjAxNDU3N10gTW9kdWxlcyBsaW5rZWQgaW46IG41cGYoT0UpIG5ldGNvbnNvbGUgdGxzKE9FKSBi
b25kaW5nIGludGVsX3JhcGxfbXNyIGludGVsX3JhcGxfY29tbW9uIHNiX2VkYWMgeDg2X3BrZ190
ZW1wX3RoZXJtYWwgaW50ZWxfcG93ZXJjbGFtcCBjb3JldGVtcCBrdm1faW50ZWwga3ZtIGlUQ09f
d2R0IGlUQ09fdmVuZG9yX3N1cHBvcnQgaXJxYnlwYXNzIGNyY3QxMGRpZl9wY2xtdWwgY3JjMzJf
cGNsbXVsIGdoYXNoX2NsbXVsbmlfaW50ZWwgYWVzbmlfaW50ZWwgY3J5cHRvX3NpbWQgbWVpX21l
IGNyeXB0ZCBnbHVlX2hlbHBlciBpcG1pX3NpIHNnIG1laSBscGNfaWNoIHBjc3BrciBqb3lkZXYg
aW9hdGRtYSBpMmNfaTgwMSBpcG1pX2RldmludGYgaXBtaV9tc2doYW5kbGVyIHdtaSBpcF90YWJs
ZXMgeGZzIGxpYmNyYzMyYyBzZF9tb2QgbWdhZzIwMCBkcm1fdnJhbV9oZWxwZXIgdHRtIGRybV9r
bXNfaGVscGVyIHN5c2NvcHlhcmVhIHN5c2ZpbGxyZWN0IHN5c2ltZ2JsdCBmYl9zeXNfZm9wcyBk
cm0gaXNjaSBsaWJzYXMgYWhjaSBzY3NpX3RyYW5zcG9ydF9zYXMgbGliYWhjaSBjcmMzMmNfaW50
ZWwgc2VyaW9fcmF3IGlnYiBsaWJhdGEgcHRwIHBwc19jb3JlIGRjYSBpMmNfYWxnb19iaXQgZG1f
bWlycm9yIGRtX3JlZ2lvbl9oYXNoIGRtX2xvZyBkbV9tb2QgW2xhc3QgdW5sb2FkZWQ6IG5pdHJv
eF9kcnZdClsgIDI3MS4wMTkzNDRdIENSMjogZmZmZjkxZDM4M2UwNTc4NAoK
--00000000000043f10c0592225e0f--
