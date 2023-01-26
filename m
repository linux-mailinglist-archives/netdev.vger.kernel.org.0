Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D3E67C62F
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 09:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbjAZIu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 03:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbjAZIuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 03:50:25 -0500
X-Greylist: delayed 307 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 26 Jan 2023 00:50:23 PST
Received: from mail.linogate.de (mail.linogate.de [213.179.141.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4D82194B
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 00:50:23 -0800 (PST)
Received: from riab.mowin.de (support.linogate.de [213.179.141.14] (may be forged))
        by mail.linogate.de with ESMTPS id 30Q8kwpE001181
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 26 Jan 2023 09:46:58 +0100
Received: from riab.mowin.de (localhost [127.0.0.1])
        (authenticated bits=128)
        by riab.mowin.de with ESMTPSA id 30Q8hxBg023402
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 09:43:59 +0100
X-Virus-Scanned: by amavisd-new at 
Received: from [192.168.0.163] ([192.168.0.163])
        by riab.mowin.de with ESMTP id 30Q8hvWX023332;
        Thu, 26 Jan 2023 09:43:57 +0100
Content-Type: multipart/mixed; boundary="------------nEQ99tltSZsUZyXEMMC1Fxnh"
Message-ID: <f4461b32-852f-da7e-a893-97e08c455e44@linogate.de>
Date:   Thu, 26 Jan 2023 09:43:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Content-Language: en-GB
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
From:   Wolfgang Nothdurft <wolfgang@linogate.de>
Subject: Problem with xfrm interface and bridged devices
X-Scanned-By: MIMEDefang 2.78 on 213.179.141.2
X-Scanned-By: MIMEDefang 2.78
X-Greylist: ACL 256 matched, not delayed by milter-greylist-4.6.2 (mail.linogate.de [213.179.141.2]); Thu, 26 Jan 2023 09:46:58 +0100 (CET)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------nEQ99tltSZsUZyXEMMC1Fxnh
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi there,

when using a xfrm interface in a bridged setup (the outgoing device is 
bridged), the incoming packets in the xfrm interface inherit the bridge 
info and confuses the netfilter connection tracking.

brctl show
bridge name     bridge id               STP enabled     interfaces
br_eth1         8000.000c29fe9646       no              eth1

This messes up the connection tracking so that only the outgoing packets 
shows up and the connections through the xfrm interface are UNREPLIED. 
When using stateful netfilter rules, the response packet will be blocked 
as state invalid.

telnet 192.168.12.1 7
Trying 192.168.12.1...

conntrack -L
tcp      6 115 SYN_SENT src=192.168.11.1 dst=192.168.12.1 sport=52476 
dport=7 packets=2 bytes=104 [UNREPLIED] src=192.168.12.1 
dst=192.168.11.1 sport=7 dport=52476 packets=0 bytes=0 mark=0 
secctx=system_u:object_r:unlabeled_t:s0 use=1

Chain INPUT (policy DROP 0 packets, 0 bytes)
     2   104 DROP_invalid  all  --  *      *       0.0.0.0/0 
0.0.0.0/0            state INVALID

Jan 26 09:28:12 defendo kernel: fw-chk drop [STATE=invalid] IN=ipsec0 
OUT= PHYSIN=eth1 MAC= SRC=192.168.12.1 DST=192.168.11.1 LEN=52 TOS=0x00 
PREC=0x00 TTL=64 ID=0 DF PROTO=TCP SPT=7 DPT=52476 WINDOW=64240 RES=0x00 
ACK SYN URGP=0 MARK=0x1000000

The attached patch removes the bridge info from the incoming packets on 
the xfrm interface, so the packet can be properly assigned to the 
connection.

Kind Regards,
Wolfgang
--------------nEQ99tltSZsUZyXEMMC1Fxnh
Content-Type: text/x-patch; charset=UTF-8;
 name="remove_inherited_bridge_info_from_skb.patch"
Content-Disposition: attachment;
 filename="remove_inherited_bridge_info_from_skb.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL25ldC94ZnJtL3hmcm1faW5wdXQuYyBiL25ldC94ZnJtL3hmcm1faW5w
dXQuYwppbmRleCA3N2U4MjAzM2FkNzAuLjU4OGNkMzhlMmU2OCAxMDA2NDQKLS0tIGEvbmV0
L3hmcm0veGZybV9pbnB1dC5jCisrKyBiL25ldC94ZnJtL3hmcm1faW5wdXQuYwpAQCAtNTM5
LDYgKzUzOSwxMSBAQCBpbnQgeGZybV9pbnB1dChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBpbnQg
bmV4dGhkciwgX19iZTMyIHNwaSwgaW50IGVuY2FwX3R5cGUpCiAJCWdvdG8gbG9jazsKIAl9
CiAKKwkvLyBzdHJpcCBicmlkZ2UgaW5mbyBmcm9tIHNrYgorCWlmIChza2JfZXh0X2V4aXN0
KHNrYiwgU0tCX0VYVF9CUklER0VfTkYpKXsKKwkJc2tiX2V4dF9kZWwoc2tiLCBTS0JfRVhU
X0JSSURHRV9ORik7CisJfQorCiAJZmFtaWx5ID0gWEZSTV9TUElfU0tCX0NCKHNrYiktPmZh
bWlseTsKIAogCS8qIGlmIHR1bm5lbCBpcyBwcmVzZW50IG92ZXJyaWRlIHNrYi0+bWFyayB2
YWx1ZSB3aXRoIHR1bm5lbCBpX2tleSAqLwo=

--------------nEQ99tltSZsUZyXEMMC1Fxnh--
