Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9D7F2229
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfKFWwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:52:12 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33195 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbfKFWwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 17:52:12 -0500
Received: by mail-pf1-f193.google.com with SMTP id c184so311309pfb.0;
        Wed, 06 Nov 2019 14:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=6eW2NPfVSQQChSqcE6wiMAD7XKSXUnYp/Sm1AwnKq6U=;
        b=LDfSPvDu0zY4Bv9hB3p8HWHYskob/kZNYs+XrsZdp+TEpYvm6V/v5bSmO6YNmZYPzx
         Gnn3CmKBt27zYP+M8JQ/Vl9rcVJEw7kAvJGgR7NP9quIvYgBlFrMEO3fYnGVceESgfsx
         bZpog7N4nOBW1BcvWp0qTshGjYINtJfHI0dl7f9wB3mq6iFShsfi9mpkThZIIlesmmX2
         rxVrhFuWDPcMpRPPE0OzmWGQ34UZ5/IPBxP2069P+A2C10aHlZnZ7N6Hzk5W4F+ONo0h
         H0z9+/6UYcW3BXD9mCHaKGf9EvRtNzcZ7+jUVbT+tCWsfzqGUM+lDFaRSqHx0nn9nFjx
         2OtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=6eW2NPfVSQQChSqcE6wiMAD7XKSXUnYp/Sm1AwnKq6U=;
        b=Js4yklScmRhofwxmeyDkRLTRM4nxsdqImn0gx2eiC9IDwLtVLSzC76qUcNqxitwrHK
         bTLr1X09owZieH+bBlO7+ZvfSKR0owQHylL9Ioo3VA8gNUgBXJN3M3y3zcpjqya9YYv3
         yLqP2nozNuYGiNp+S2h5of9quNvLzZDX4vOjpz7EbOCYP1r1aL8vQawpUXXbfcndxtZx
         QF8whtshqdxDNj+949OWY2dx2ygimlBIJ1aQ9g3H/YLASTe2wlyl8ZDkS+ZmsrwGyCzO
         LV4A104JLHSpn2B16RD3EwCZWTnwjqB0KBIBqQ94rzG7Q7bVkYtG4iaJSzB3vDObb7Nc
         Exaw==
X-Gm-Message-State: APjAAAWxMDT5mkR+yZSWQdi46DFxI0UYkIaePXipE0kMdO3bIW5/81w1
        iCWAy9+JeKpWt4JhGewvH9ObXwwI7Q==
X-Google-Smtp-Source: APXvYqyfdLZ5/jZwwKxwKPcF+jjk5g7Y1ItTbm8zGsuYYV9P0yKfg7LQMT1481yggBU3pXYAAC55ww==
X-Received: by 2002:a63:e84f:: with SMTP id a15mr325260pgk.309.1573080731145;
        Wed, 06 Nov 2019 14:52:11 -0800 (PST)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id q26sm102679pgk.60.2019.11.06.14.52.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 06 Nov 2019 14:52:10 -0800 (PST)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     fw@strlen.de, pablo@netfilter.org, davem@davemloft.net,
        kadlec@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] [net]: Fix skb->csum update in inet_proto_csum_replace16().
Date:   Wed,  6 Nov 2019 14:52:08 -0800
Message-Id: <1573080729-3102-1-git-send-email-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-------------Issue [BUG in current code]:-------------

IPV6 UDP packet is dropped by kernel in function udp6_csum_init(), when netfilter for NF_NAT_MANIP_SRC\DST is applied.
    
Counter increased: Udp6InCsumErrors. Note: incoming UPD6 packet has correct UDP checksum. 


-------------Reproduction steps: (using IPV6 UDP DNS Query)--- [linux kernel any version > 4.9.110]-------------

1.) Set an SNAT entry in /etc/iptables/rules.v6 as show below.
```
    -A POSTROUTING -p udp -m udp --dport 53 -o Ethernet+ -j SNAT --to-source 2a04:xxxx:xxxx:4::2 (Masked)
```
Note: Above rule will change ipv6 source address to 2a04:xxxx:xxxx:4::2 for outgoing UDPv6 DNS packet , and will change the ipv6 destination address from 2a04:xxxx:xxxx:4::2 to original ipv6 address for incoming DNS response.

2.) Apply the iptable changes.
```
    switch$ sudo /etc/network/if-pre-up.d/iptables
```
3.) Run a DNS query using IPV6 DNS server for any site. We can observe that DNS query is timed out.
```
    switch$ host facebook.com 2a04:xxxx:xx:1::c216
    ;; connection timed out; no servers could be reached
```

---------------Details of issue----------------

1.) On incoming path: 
Function Trace: udp_error()-->nf_checksum()-->nf_ip6_checksum():

In function nf_ip6_checksum(); checksum is verified for incoming packet. Here skb->data points to IPV6 HEADER and ip_summed == CHECKSUM_NONE at start. So after a call to __skb_checksum_complete, skb->csum will store the 16-bit sum of [ipv6 header + UDP header + UDP data].

Checksum verification will be successful here, because csum_ipv6_magic() subtracts 16-bit sum of IPv6 header from 16-bit sum of Pseudo header.

Note: UDP checksum = ~[pseudo header + UDP header + UDP data].


2.) SNAT iptable rule processing, 

Function Trace: nf_nat_ipv6_manip_pkt()--> l4proto_manip_pkt()-->udp_manip_pkt()-->__udp_manip_pkt()-->nf_csum_update()---> nf_nat_ipv6_csum_update()-->inet_proto_csum_replace16():

In function inet_proto_csum_replace16(), first udp_header checksum field will be updated as below, because of the NF_NAT_MANIP_SRC\DST manipulation,  I.e to reflect IPV6 src\dst address change in IPV6 header.
```
        *sum = csum_fold(csum_partial(diff, sizeof(diff),
                 ~csum_unfold(*sum)));
```

Since skb->csum includes udp header checksum field, skb->csum will also go through similar calculation to reflect udp header checksum field change.
```
    if (skb->ip_summed == CHECKSUM_COMPLETE && pseudohdr)
            skb->csum = ~csum_partial(diff, sizeof(diff),
                          ~skb->csum);
```
After this update, skb->csum = [Original IPV6 Header + Modified UDP header + UDP data]



3.) Then in function nf_nat_ipv6_manip_pkt(), ipv6 header will be updated to have target IPV6 src\dst address:
    
```
    if (maniptype == NF_NAT_MANIP_SRC)

        ipv6h->saddr = target->src.u3.in6;
    else
        ipv6h->daddr = target->dst.u3.in6;

```
Here we do not update skb->csum. So skb->csum will still be equal to [Original IPV6 Header + Modified UDP header + UDP data]. 
**BUG BUG BUG**: This is the bug, skb->csum must be updated to reflect this change in IPV6 SRC Address.

Ideally change in UDP header checksum field and change in IPV6 SRC address cancels each other in this case, so no update was needed in skb->csum in function inet_proto_csum_replace16().

4.) IPV6 header processing: 

Function Trace: ip6_input() --> ip6_input_finish() --> ip6_protocol_deliver_rcu():

In ip6_protocol_deliver_rcu(), 16-bit sum of IPV6 header will be subtracted from skb->csum.

```
    skb_postpull_rcsum(skb, skb_network_header(skb),
                       skb_network_header_len(skb));
```

This is the sum of new IPV6 header with modified IPV6 Source\dest address. After this subtraction 

skb->csum = [Original IPV6 Header + Modified UDP header + UDP data] - [Modified IPv6 Header]
This is wrong value of skb->csum.


5.) UDP Header Checksum init:

Function Trace: __udp6_lib_rcv() --> udp6_csum_init() -->  __skb_checksum_validate_complete()

In  __skb_checksum_validate_complete() below condition will never met. Because value of skb->csum is unexpected. 
```
    if (skb->ip_summed == CHECKSUM_COMPLETE) {
        if (!csum_fold(csum_add(psum, skb->csum))) {
            skb->csum_valid = 1;
            return 0;
        }
    }
```

In udp6_csum_init(), below check will be true:
```
if (skb->ip_summed == CHECKSUM_COMPLETE && !skb->csum_valid) {
        /* If SW calculated the value, we know it's bad */
        if (skb->csum_complete_sw)
            return 1;
```

and this packet will be dropped in  __udp6_lib_rcv() due to below check

```
if (udp6_csum_init(skb, uh, proto))
        goto csum_error;
.......
.......

csum_error:
    __UDP6_INC_STATS(net, UDP_MIB_CSUMERRORS, proto == IPPROTO_UDPLITE);
```



-------------------Related JPROBE LOGS:-------------------
```
Oct 19 05:15:01.420147 asw03 NOTICE kernel: [350574.264081]  nf_ip6_checksum: dataoff=40   
Oct 19 05:15:01.420180 asw03 NOTICE kernel: [350574.264084]  nf_ip6_checksum: skb:ffff9faa71cbc500 ip_sum=0 csum_valid=0 csum_com_sw=0 csum=0
```
[Explanation]: dataoff = 40 for ipv6 header and checksum is not verified yet, so skb->csum = 0.

```
Oct 19 05:15:01.420190 asw03 NOTICE kernel: [350574.264090]  nf_ip6_checksum: len:228 psum:ffffd68e csum=2e57fb19 sum=0
```
[Explanation]: psum = pseudo header sum - ipv6 header sum. Csum = skb->csm = [ipv6 header + UDP header + UDP data]
psum + csum (16-bit sum) = ffff + d68e + 2e57 + fb19 = 0x2FFFD = 0xFFFD + 0x2 = 0xFFFF. Skb->len is 228 here.


```
Oct 19 05:15:01.420199 asw03 NOTICE kernel: [350574.264105] inet_proto_csum_replace16 : prev_hw_check=7feb uh_check=01cb
```
[Explanation]: With SNAT, IPV6 address will change from 2axx:xxxx:00xx:0004:0000:0000:0000:0002 to 2axx:xxx:00xx:2082:0000:0000:0000:0002. So the 16 bit diff is: 0x2082 - 0x0004 = 0x207E . So UDP header checksum changes from 0xEB7f to 0xCB01, Diff = ~(0x207E). [Printed without htons above.]


```
Oct 19 05:15:01.420203 asw03 NOTICE kernel: [350574.264107] inet_proto_csum_replace16: skb:ffff9faa71cbc500 ip_sum=2 csum_valid=1 csum_com_sw=1 csum= b037fb18
```c
[Explanation]: Skb->csum changed according to udp header checksum diff: 16-bit diff for (b037fb18 - 2e57fb19) = ~htons(0x207E).


```
Oct 19 05:15:01.420218 asw03 NOTICE kernel: [350574.264116] ip6_rcv_finish: skb:ffff9faa71cbc500 ip_sum=2 csum_valid=1 csum_com_sw=1 csum=b037fb18
Oct 19 05:15:01.420227 asw03 NOTICE kernel: [350574.264135] __udp6_lib_rcv: src: 2axx:xxxx:00xx:0001:0000:0000:0000:c216 dst: 2axx:xxxx:00xx:2082:0000:0000:0000:0002 port: 53 uh_check: cb01
Oct 19 05:15:01.420230 asw03 NOTICE kernel: [350574.264137] __udp6_lib_rcv: skb:ffff9faa71cbc500 ip_sum=2 csum_valid=1 csum_com_sw=1 csum=57e294da
```
[Explanation]: Between ip6_rcv_finish and __udp6_lib_rcv, 16-bit sum of ipv6 header is subtracted from skb->csum. So skb->csum = 57e294da at __udp6_lib_rcv.


```
Oct 19 05:15:01.420236 asw03 NOTICE kernel: [350574.264140] __udp6_lib_rcv_post: len:188 psum:ffff9522 csum=57e294da
```
Here psum + csum = ffff + 9522 + 57e2 + 94da = 0x281DD = 0x81DF = ~(htons(207E)) [same delta]. Which shows that SKB_CSUM should be updated due to change IPV6 address.


--------------FIX ------------------------

No need to update skb->csum in function inet_proto_csum_replace16(), even if skb->ip_summed == CHECKSUM_COMPLETE, because change in L4
header checksum field and change in IPV6 header cancels each other for skb->csum calculation. This is because skb->csum includes sum of 
[IPv6 Header + L4 Header + L4 Data]


-----------------------
Interesting Facts:

------------------Why Problem is not seen for IPV4--------------

IPV4 suffers with similar issue, but since 16-bit sum of IPV4 header is always zero [Due to IPv4 header checksum present in IPV4 header]. Skb->csum as per below state will correct:

skb->csum = [Original IPV6 Header + Modified UDP header + UDP data - Modified IPv6 Header] = [Modified UDP header + UDP data]


------------------Why Problem is not seen for IPV6 TCP--------------

Even though skb->csum will be incorrect, when packet hit tcp_v6_rcv()--> skb_checksum_init()--> __skb_checksum_validate().

TCP code starts checksum calculation from scratch by assigning pseudo header sum in skb->csum and by returning 0 from skb_checksum_init().

With this fix,  validation will be successful in __skb_checksum_validate() even for tcpv6 packet, so kernel will not recalculate checksum.


------------------Why Problem is not seen in linux kernel version < 3.16--------------

Call to udp_csum_pull_header(skb) in udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb) has exposed the issue for UDPv6.

-------------------------------------------------------------------------------------

Note: 

-- Kindly let me know, If needed I can present entire packet and example with checksum calculation at each stage.

-------------------------------------------------------------------------------------



---------------------------Testing (with JPROBE LOGS) [AFTER FIX UDPv6 DNS query works fine]:---------------------------


1.) 
```
pchaudha@asw03:~$ sudo cat /etc/iptables/rules.v6 | grep SNAT
# SNAT
-A POSTROUTING -p tcp -m tcp --dport 443 -o Ethernet+ -j SNAT --to-source 2a04:xxxx:62:4::2
-A POSTROUTING -p udp -m udp --dport 53 -o Ethernet+ -j SNAT --to-source 2a04:xxxx:62:4::2
-A POSTROUTING -p tcp -m tcp --dport 53 -o Ethernet+ -j SNAT --to-source 2a04:xxxx:62:4::2
```


2.)
```
 pchaudha@asw03:~$ sudo /etc/network/if-pre-up.d/iptables
```
3.) UDPv6 DNS query:
```
pchaudha@asw03:~$ host facebook.com 2a04:xxxx:xx:1::c216
Using domain server:
Name: 2a04:xxxx:32:1::c216
Address: 2a04:xxxx:32:1::c216#53
Aliases:

facebook.com has address 157.240.11.35
facebook.com has IPv6 address 2a03:2880:f10d:183:face:b00c:0:25de
facebook.com mail is handled by 10 smtpin.vvv.facebook.com.
```
4.) JPROBE LOGS: 
```
Oct 22 05:51:20.748153 asw03 NOTICE kernel: [611954.922595] nf_nat_ipv6_manip_pkt: skb:ffff9faa7c9bf400 t->dst.protonum=17
Oct 22 05:51:20.748186 asw03 NOTICE kernel: [611954.922600] inet_proto_csum_replace16: skb:ffff9faa7c9bf400 ips=2 csumv=1 csumsw=1 csum=4914e05c
Oct 22 05:51:20.748195 asw03 NOTICE kernel: [611954.922605] ip6_rcv_finish: skb:ffff9faa7c9bf400 ips=2 csumv=1 csumsw=1 csum=4914e05c
```

5.) TCPv6 query:
```
pchaudha@asw03:~$ host -T facebook.com 2a04:xxxx:32:1::c216
Using domain server:
Name: 2a04:xxxx:32:1::c216
Address: 2a04:xxxx:32:1::c216#53
Aliases:

facebook.com has address 31.13.70.36
facebook.com has IPv6 address 2a03:2880:f10d:183:face:b00c:0:25de
facebook.com mail is handled by 10 smtpin.vvv.facebook.com.
--------------------------
```

6.) JPROBE LOGS:
```
Oct 22 18:13:29.199793 asw03 NOTICE kernel: [656483.605018] nf_nat_ipv6_manip_pkt: skb:ffff9faab3e79400 t->dst.protonum=6
Oct 22 18:13:29.199826 asw03 NOTICE kernel: [656483.605032] inet_proto_csum_replace16: skb:ffff9faab3e79400 ips=2 csumv=1 csumsw=1 csum=c6796dec
Oct 22 18:13:29.199835 asw03 NOTICE kernel: [656483.605038] ip6_rcv_finish: skb:ffff9faab3e79400 ips=2 csumv=1 csumsw=1 csum=c6796dec
```

Praveen Chaudhary (1):
  [net]: Fix skb->csum update in inet_proto_csum_replace16().

 net/core/utils.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

-- 
2.7.4

