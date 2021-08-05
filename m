Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DB13E1C2E
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242354AbhHETKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:10:35 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:21560 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242056AbhHETKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 15:10:34 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628190620; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=nqq7puYdZare1wTZSwwTfBn9rYP+HFD1uwErPWMP3Ow=;
 b=sI+9BkHFKWnUResbajlT++zoRWak+jhWlK6R2PznF25LMdpQSsAb737/OKjt19DK+QgiU4Rr
 fuYpPzcj5fMT8t+on4tDjQBnrYEZdD5Un6ntyJAWQD3cmfNIbUa8JxQlLN9cVpLAxCmLpEne
 Hc8w/XmklV33EHiqC0msTthz6kA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 610c37901b76afb4467b10ba (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 05 Aug 2021 19:10:08
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9F31FC433D3; Thu,  5 Aug 2021 19:10:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 68785C43460;
        Thu,  5 Aug 2021 19:10:07 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 05 Aug 2021 13:10:07 -0600
From:   subashab@codeaurora.org
To:     Aleksander Morgado <aleksander@aleksander.es>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Daniele Palmas <dnlplm@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        stranche@codeaurora.org
Subject: Re: RMNET QMAP data aggregation with size greater than 16384
In-Reply-To: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
References: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
Message-ID: <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-31 16:45, Aleksander Morgado wrote:
> Hey Subash,
> 
> I'm playing with the whole QMAP data aggregation setup with a USB
> connected Fibocom FM150-AE module (SDX55).
> See https://gitlab.freedesktop.org/mobile-broadband/libqmi/-/issues/71
> for some details on how I tested all this.
> 
> This module reports a "Downlink Data Aggregation Max Size" of 32768
> via the "QMI WDA Get Data Format" request/response, and therefore I
> configured the MTU of the master wwan0 interface with that same value
> (while in 802.3 mode, before switching to raw-ip and enabling
> qmap-pass-through in qmi_wwan).
> 
> When attempting to create a new link using netlink, the operation
> fails with -EINVAL, and following the code path in the kernel driver,
> it looks like there is a check in rmnet_vnd_change_mtu() where the
> master interface MTU is checked against the RMNET_MAX_PACKET_SIZE
> value, defined as 16384.
> 
> If I setup the master interface with MTU 16384 before creating the
> links with netlink, there's no error reported anywhere. The FM150
> module crashes as soon as I connect it with data aggregation enabled,
> but that's a different story...
> 
> Is this limitation imposed by the RMNET_MAX_PACKET_SIZE value still a
> valid one in this case? Should changing the max packet size to 32768
> be a reasonable approach? Am I doing something wrong? :)
> 
> This previous discussion for the qmi_wwan add_mux/del_mux case is
> relevant:
> https://patchwork.ozlabs.org/project/netdev/patch/20200909091302.20992-1-dnlplm@gmail.com/..
> The suggested patch was not included yet in the qmi_wwan driver and
> therefore the user still needs to manually configure the MTU of the
> master interface before setting up all the links, but at least there
> seems to be no maximum hardcoded limit.
> 
> Cheers!

Hi Aleksander

The downlink data aggregation size shouldn't affect the MTU.
MTU applies for uplink only and there is no correlation with the 
downlink path.
Ideally, you should be able to use standard 1500 bytes (+ additional 
size for MAP header)
for the master device. Is there some specific network which is using
greater than 1500 for the IP packet itself in uplink.

--
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
