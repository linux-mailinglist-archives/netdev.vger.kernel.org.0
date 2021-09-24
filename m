Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5882416CEA
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 09:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244412AbhIXHio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 03:38:44 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:51779 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244398AbhIXHio (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 03:38:44 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632469031; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=q3sgHaNoeo9y/c2zl8fCMwgMb5gjvNFL7fPrugk3DZA=;
 b=bqI7TlZYOSFWzYw2MuZGYGVt4dN26Xv1XenleNkS4cK1aCinnmYr1p6bOLX5TP6KaH9+VN8B
 DXChz+ikj/iytV/KygdtDuL4v7kQxUM2J7BxVJcQnkBxyDvkbvxLUrGiyYuQwde9DAS1yAB9
 SizJ4t8SABVwT3yb1CObc6xJqzE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 614d801eec62f57c9a559950 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 24 Sep 2021 07:37:02
 GMT
Sender: youghand=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 76A82C43616; Fri, 24 Sep 2021 07:37:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: youghand)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4A507C4338F;
        Fri, 24 Sep 2021 07:37:00 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 24 Sep 2021 13:07:00 +0530
From:   Youghandhar Chintala <youghand@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Abhishek Kumar <kuabhs@chromium.org>, Felix Fietkau <nbd@nbd.name>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: Re: [PATCH 2/3] mac80211: Add support to trigger sta disconnect on
 hardware restart
In-Reply-To: <d5cfad1543f31b3e0d8e7a911d3741f3d5446c57.camel@sipsolutions.net>
References: <20201215172352.5311-1-youghand@codeaurora.org>
 <f2089f3c-db96-87bc-d678-199b440c05be@nbd.name>
 <ba0e6a3b783722c22715ae21953b1036@codeaurora.org>
 <CACTWRwt0F24rkueS9Ydq6gY3M-oouKGpaL3rhWngQ7cTP0xHMA@mail.gmail.com>
 (sfid-20210205_225202_513086_43C9BBC9)
 <d5cfad1543f31b3e0d8e7a911d3741f3d5446c57.camel@sipsolutions.net>
Message-ID: <66ba0f836dba111b8c7692f78da3f079@codeaurora.org>
X-Sender: youghand@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes and felix,

We have tested with DELBA experiment during post SSR, DUT packet seq 
number and tx pn is resetting to 0 as expected but AP(Netgear R8000) is 
not honoring the tx pn from DUT.
Whereas when we tested with DELBA experiment by making Linux android 
device as SAP and DUT as STA with which we don’t see any issue. Ping got 
resumed post SSR without disconnect.

Please find below logs collected during my test for reference.

192.168.0.15(AtherosC_12:af:af)  ===> DUT IP and MAC
192.168.0.55(Netgear_d2:93:3d)   ===> AP IP and MAC

No.     Time           Source                Destination           
Protocol Channel    Sequence number Protected flag Block Ack Starting 
Sequence Control (SSC) CCMP Ext. Initialization Vector Action code TID   
      Info
     474 22.186433      192.168.0.15          192.168.0.55          ICMP  
    44         37              Data is protected                          
                  0x000000000026                              0          
Echo (ping) request  id=0x0d00, seq=256/1, ttl=64 (reply in 480)

No.     Time           Source                Destination           
Protocol Channel    Sequence number Protected flag Block Ack Starting 
Sequence Control (SSC) CCMP Ext. Initialization Vector Action code TID   
      Info
     480 22.188371      192.168.0.55          192.168.0.15          ICMP  
    44         5               Data is protected                          
                  0x000000000011                              6          
Echo (ping) reply    id=0x0d00, seq=256/1, ttl=64 (request in 474)

No.     Time           Source                Destination           
Protocol Channel    Sequence number Protected flag Block Ack Starting 
Sequence Control (SSC) CCMP Ext. Initialization Vector Action code TID   
      Info
     483 22.246335      192.168.0.15          192.168.0.55          ICMP  
    44         38              Data is protected                          
                  0x000000000027                              0          
Echo (ping) request  id=0x1258, seq=11/2816, ttl=64 (reply in 489)

No.     Time           Source                Destination           
Protocol Channel    Sequence number Protected flag Block Ack Starting 
Sequence Control (SSC) CCMP Ext. Initialization Vector Action code TID   
      Info
     489 22.248127      192.168.0.55          192.168.0.15          ICMP  
    44         13              Data is protected                          
                  0x000000000012                              0          
Echo (ping) reply    id=0x1258, seq=11/2816, ttl=64 (request in 483)


The above pings(with TID 0) are before SSR. As soon as DUT recovers 
after SSR, DUT is sending DELBAs to AP.

No.     Time           Source                Destination           
Protocol Channel    Sequence number Protected flag Block Ack Starting 
Sequence Control (SSC) CCMP Ext. Initialization Vector Action code       
                     TID        Info
     546 26.129127      AtherosC_12:af:af     Netgear_d2:93:3d      
802.11   44         4               Data is not protected                
                                                     Delete Block Ack     
0x0       Action, SN=4, FN=0, Flags=........C

No.     Time           Source                Destination           
Protocol Channel    Sequence number Protected flag Block Ack Starting 
Sequence Control (SSC) CCMP Ext. Initialization Vector Action code       
                     TID        Info
     548 26.129977      AtherosC_12:af:af     Netgear_d2:93:3d      
802.11   44         5               Data is not protected                
                                                      Delete Block Ack    
0x6        Action, SN=5, FN=0, Flags=........C


After SSR, we started ping traffic with TID 7 and 0. ping is successful 
for TID 7 and failed for TID 0.
For TID 0, ping requests tx PN is reset to 0 but it seems AP is not 
reset its PN hence we see this ping failure for TID 0.
Whereas TID 7 ping success because we started it after SSR.


No.     Time           Source                Destination           
Protocol Channel    Sequence number Protected flag Block Ack Starting 
Sequence Control (SSC) CCMP Ext. Initialization Vector Action code TID   
      Info
     557 26.355256      192.168.0.15          192.168.0.55          ICMP  
    44         0               Data is protected                          
                  0x000000000001                              0          
Echo (ping) request  id=0x1258, seq=15/3840, ttl=64 (no response found!)

No.     Time           Source                Destination           
Protocol Channel    Sequence number Protected flag Block Ack Starting 
Sequence Control (SSC) CCMP Ext. Initialization Vector Action code TID   
      Info
     571 27.376895      192.168.0.15          192.168.0.55          ICMP  
    44         1               Data is protected                          
                  0x000000000002                              0          
Echo (ping) request  id=0x1258, seq=16/4096, ttl=64 (no response found!)

No.     Time           Source                Destination           
Protocol Channel    Sequence number Protected flag Block Ack Starting 
Sequence Control (SSC) CCMP Ext. Initialization Vector Action code TID   
      Info
     588 28.400946      192.168.0.15          192.168.0.55          ICMP  
    44         2               Data is protected                          
                  0x000000000003                              0          
Echo (ping) request  id=0x1258, seq=17/4352, ttl=64 (no response found!)

No.     Time           Source                Destination           
Protocol Channel    Sequence number Protected flag Block Ack Starting 
Sequence Control (SSC) CCMP Ext. Initialization Vector Action code TID   
      Info
     600 29.424881      192.168.0.15          192.168.0.55          ICMP  
    44         3               Data is protected                          
                  0x000000000004                              0          
Echo (ping) request  id=0x1258, seq=18/4608, ttl=64 (no response found!)


Below ping packets are with TID 7

No.     Time           Source                Destination           
Protocol Channel    Sequence number Protected flag Block Ack Starting 
Sequence Control (SSC) CCMP Ext. Initialization Vector Action code TID   
      Info
     622 30.898249      192.168.0.15          192.168.0.55          ICMP  
    44         0               Data is protected                          
                  0x000000000006                              7          
Echo (ping) request  id=0x1276, seq=1/256, ttl=64 (reply in 626)

No.     Time           Source                Destination           
Protocol Channel    Sequence number Protected flag Block Ack Starting 
Sequence Control (SSC) CCMP Ext. Initialization Vector Action code TID   
      Info
     626 30.900015      192.168.0.55          192.168.0.15          ICMP  
    44         0               Data is protected                          
                  0x000000000013                              7          
Echo (ping) reply    id=0x1276, seq=1/256, ttl=64 (request in 622)

No.     Time           Source                Destination           
Protocol Channel    Sequence number Protected flag Block Ack Starting 
Sequence Control (SSC) CCMP Ext. Initialization Vector Action code TID   
      Info
     644 31.897456      192.168.0.15          192.168.0.55          ICMP  
    44         1               Data is protected                          
                  0x000000000008                              7          
Echo (ping) request  id=0x1276, seq=2/512, ttl=64 (reply in 648)

No.     Time           Source                Destination           
Protocol Channel    Sequence number Protected flag Block Ack Starting 
Sequence Control (SSC) CCMP Ext. Initialization Vector Action code TID   
      Info
     648 31.899266      192.168.0.55          192.168.0.15          ICMP  
    44         1               Data is protected                          
                  0x000000000014                              7          
Echo (ping) reply    id=0x1276, seq=2/512, ttl=64 (request in 644)

Regards,
Youghandhar


On 2021-02-12 14:07, Johannes Berg wrote:
> On Fri, 2021-02-05 at 13:51 -0800, Abhishek Kumar wrote:
>> Since using DELBA frame to APs to re-establish BA session has a
>> dependency on APs and also some APs may not honor the DELBA frame.
> 
> 
> That's completely out of spec ... Can you say which AP this was?
> 
> You could also try sending a BAR that updates the SN.
> 
> johannes

Regards,
Youghandhar
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a 
member
of Code Aurora Forum, hosted by The Linux Foundation
