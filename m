Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D326DDE6C
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 16:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjDKOrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 10:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjDKOrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 10:47:51 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3B6122
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 07:47:47 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id t14so10614797lft.7
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 07:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681224465;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TtALlpw22r66XpgLquDohdDaRxrp/OIiA1vy5tXnrrA=;
        b=dxdftokd38in2cfZz8838QQ48JyiLDHlJNJq5otIuBieLnnQfL1tn6/WiGFgCfu23G
         WEH8X+c1GnI3vD7l+WuxzieHiMdm4JrJPeLYdewAK/nbOWGDgZD3jALrOVjW7zRxWu8W
         dPsGbrO9iVbZyDwUVJjSCDpaOKJa7qULFUNpzdIWnqzQJSheUqL17wF/+OvweoamWCo9
         IeDYIOcn8buTwQf1WwkN86UvghU8gDU1wGkv224A2fecvNnMlY/GlIGwR4B6P+Obr3d6
         h6NC8QKFmrHYCY3FbuqpU5NGaATkGzOw6UWF5/TEyXGaJLkUMNCD4DWHPgg5qz/sdBEg
         0DgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681224465;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TtALlpw22r66XpgLquDohdDaRxrp/OIiA1vy5tXnrrA=;
        b=VPoNDZh9sV8AJ8W0ButcRW/zrjH9KFlE7WTIG692YqpJ/s3RtGXs8GZqUGPcsAzdCj
         oCxDPMLAUevj4xutEx1Eaqgjnj1jjIFXr0C4q5VNGTpgBi+4/vLn7cPs6JlwuMU3LVQ2
         cqtiIlUZgCP3QTJD6EUMV/2rB3vHtMGzSAYPtTqaTOXEVXk0v8rTFAoeyWulKVq0KrmO
         zpevWwcWzVL1Ae3z0gjH8UdR4fqXrH8PFko2JkS6OTIxPvxCtdBMr0aPGpPoNghoZd9e
         q0sQslZIWvVjyrTqqUh6w+OGtv/Ma6uqLzS6f5rgwWTeQjSAi0Osj5ChUEMtFntBYD+3
         WEvg==
X-Gm-Message-State: AAQBX9cSZgN/7V/QWQj1Y5O4pN4R9WuCby4fkGOdrk/WH59Why8ZU9ct
        SdBhNQMI3ydrfPeIQp3VoU1vqN53XlKJKuSP/hcGzB5d/lbOig==
X-Google-Smtp-Source: AKy350YeN/FyK/YDnXHk0gwgN+LNDwpm5ynPCnKOcyZ7fXM0SK9XYSRvXiYA6PQxr+J5AoeL3oYGi8zvHDtZHZ2Ra4s=
X-Received: by 2002:a19:ac07:0:b0:4ec:8aff:847f with SMTP id
 g7-20020a19ac07000000b004ec8aff847fmr1888891lfc.12.1681224465282; Tue, 11 Apr
 2023 07:47:45 -0700 (PDT)
MIME-Version: 1.0
From:   Aleksey Shumnik <ashumnik9@gmail.com>
Date:   Tue, 11 Apr 2023 17:47:34 +0300
Message-ID: <CAJGXZLgcH6bjmj7YR-hAWpEQW1CPjEcOdMN01hqsVk18E4ScZQ@mail.gmail.com>
Subject: [BUG] In af_packet.c::dev_parse_header() skb.network_header does not
 point to the network header
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, waltje@uwalt.nl.mugnet.org,
        gw4pts@gw4pts.ampr.org, xeb@mail.ru, kuznet@ms2.inr.ac.ru,
        rzsfl@rz.uni-sb.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear maintainers,

I wrote the ip6gre_header_parser() function in ip6_gre.c, the
implementation is similar to ipgre_header_parser() in ip_gre.c. (By
the way, it is strange that this function is not implemented in
ip6_gre.c)
The implementation of the function is presented below.
It should parse the ip6 header and take the source address and its
length from there. To get a pointer to the ip header, it is logical to
use skb_network_header(), but it does not work correctly and returns a
pointer to payload (skb.data).
Also in ip_gre.c::ipgre_header_parser() skb_mac_header() returns a
pointer to the ip header and everything works correctly (although it
seems that this is also an error, because the pointer to the mac
header should have been returned, and logically the
skb_network_header() function should be applied), but in ip6_gre.c all
skb_mac_header(), skb_network_header(), skb_tranport_header() returns
a pointer to payload (skb.data).
This function is called when receiving a packet and parsing it in
af_packet.c::packet_rcv() in dev_parse_header().
The problem is that there is no way to accurately determine the
beginning of the ip header.

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 90565b8..0d0c37b 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1404,8 +1404,16 @@ static int ip6gre_header(struct sk_buff *skb,
struct net_device *dev,
  return -t->hlen;
 }

+static int ip6gre_header_parse(const struct sk_buff *skb, unsigned char *haddr)
+{
+ const struct ipv6hdr *ipv6h = (const struct ipv6hdr *) skb_mac_header(skb);
+ memcpy(haddr, &ipv6h->saddr, 16);
+ return 16;
+}
+
 static const struct header_ops ip6gre_header_ops = {
  .create = ip6gre_header,
+ .parse = ip6gre_header_parse,
 };

 static const struct net_device_ops ip6gre_netdev_ops = {

Would you answer whether this behavior is an error and why the
behavior in ip_gre.c and ip6_gre.c differs?

Regards,
Aleksey
