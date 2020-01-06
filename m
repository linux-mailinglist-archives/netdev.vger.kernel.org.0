Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF28130BFC
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 03:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbgAFCEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 21:04:31 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:60330 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727210AbgAFCEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 21:04:31 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1578276270; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=ibkKkQF713Ci0VoGdUa5r7/qydExaOgwC183n6zUSwg=;
 b=hiWOUE/13fxRR01sjBApoJdxOUHg4FvAGWY4pWqjJUbFeKRabO607OPKHNH1vJEsIyMJbXyA
 XiCOLrRxCb2Arxrzx0PAFh4Z2tW8VnUAgYnivP/lvmNoMShjVQ70CPumUu/NwjHUv3eWKhov
 gYewIlZ/moyP+u52alPBb+fbUa8=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e1295aa.7f2e0b6cb110-smtp-out-n03;
 Mon, 06 Jan 2020 02:04:26 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2AC92C4479F; Mon,  6 Jan 2020 02:04:26 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: wgong)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B9C18C43383;
        Mon,  6 Jan 2020 02:04:25 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 06 Jan 2020 10:04:25 +0800
From:   Wen Gong <wgong@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: Re: [PATCH v2] net: qrtr: fix len of skb_put_padto in
 qrtr_node_enqueue
In-Reply-To: <20200105.144704.221506192255563950.davem@davemloft.net>
References: <20200103045016.12459-1-wgong@codeaurora.org>
 <20200105.144704.221506192255563950.davem@davemloft.net>
Message-ID: <2540a09c73dd896bb793924275bdab0e@codeaurora.org>
X-Sender: wgong@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-06 06:47, David Miller wrote:
> From: Wen Gong <wgong@codeaurora.org>
> Date: Fri,  3 Jan 2020 12:50:16 +0800
> 
>> The len used for skb_put_padto is wrong, it need to add len of hdr.
> 
> Thanks, applied.
> 
> There is another bug here, skb_put_padto() returns an error and frees
> the SKB when the put fails.  There really needs to be a check here,
> because currently the code right now will keep using the freed up
> skb in that situation.
> 

Thanks David.

Yes, __skb_put_padto will return -ENOMEM if __skb_pad fail.
I think it can return the same error immediately and do not do the next 
steps in qrtr_node_enqueue.
> Thanks.
