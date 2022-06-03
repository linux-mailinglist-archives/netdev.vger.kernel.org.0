Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98FF853CA2B
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 14:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244405AbiFCMsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 08:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236718AbiFCMsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 08:48:14 -0400
X-Greylist: delayed 1477 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Jun 2022 05:48:10 PDT
Received: from if35.nano.lv (m2-if35.nano.lv [85.31.97.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3D3DFD1;
        Fri,  3 Jun 2022 05:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=3a-alliance.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:Cc:From:To:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BvXX60Q1GjUuVRCBAuhAlIuikIw7yhdZQWVAmf+wQXY=; b=pPbaM7KQbwM6aaQNmC0IQaJiLH
        zkS59zFNfwUYEU6Q6LuUZT3KExfgiAyGfWeM3sCYkhINQ2ALru3vDkznufVAA/b3DNsa4IvQbAU2r
        qETytlM4TyxcTOrZP7abaplU5z4UDPl1YkMf1NyNvk9Oi7E9S7OUMkaIp13KG2tKkQvE=;
Received: from [46.109.159.121] (port=57530 helo=[192.168.1.241])
        by if35.nano.lv with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <am@3a-alliance.com>)
        id 1nx6Kt-006BUO-AX;
        Fri, 03 Jun 2022 15:23:27 +0300
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        david.lebrun@uclouvain.be
From:   Anton Makarov <am@3a-alliance.com>
Cc:     regressions@lists.linux.dev, stable@vger.kernel.org
Subject: [REGRESSION] net: SRv6 End.DT6 function is broken in VRF mode
Message-ID: <7e315ff1-e172-16c3-44b5-0c83c4c92779@3a-alliance.com>
Date:   Fri, 3 Jun 2022 15:23:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - if35.nano.lv
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 3a-alliance.com
X-Get-Message-Sender-Via: if35.nano.lv: authenticated_id: am@3a-alliance.com
X-Authenticated-Sender: if35.nano.lv: am@3a-alliance.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#regzbot introduced: b9132c32e01976686efa26252cc246944a0d2cab

Hi All!

Seems there is a regression of SRv6 End.DT6 function in VRF mode. In the 
following scenario packet is decapsulated successfully on vrf10 
interface but not forwarded to vrf10's slave interface:

ip netns exec r4 ip -6 nexthop add id 1004 encap seg6local action 
End.DT6 vrftable 10 dev vrf10

ip netns exec r4 ip -6 route add fcff:0:4:200:: nhid 1004


In End.DT6 legacy mode everything works good:

ip netns exec r4 ip -6 nexthop add id 1004 encap seg6local action 
End.DT6 table 10 dev vrf10

ip netns exec r4 ip -6 route add fcff:0:4:200:: nhid 1004


The issue impacts even stable v5.18.1. Please help to fix it.


Thanks!

Anton


