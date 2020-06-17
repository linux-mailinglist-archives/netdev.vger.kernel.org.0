Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CE21FD585
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 21:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgFQTl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 15:41:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30206 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726558AbgFQTlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 15:41:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592422914;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FvAwU7BxjY8hKbO+SxVjRBLEMfAqHAfjpkXck0DeCAc=;
        b=Q07RVqVP0Us+ITutEXQH1YIrcDtcgff4AVyoky6KyOhTuhaVCztd78zEvG+KVKS6zX9tcA
        2+iyylIGjwAIdEp+dmxujP+OqxcAJ/dZ8XFsZnV08PBP9AUaLtiU6SUp4lEe5tXH/gEuqn
        +EsxMFqbiQ3nwIvK8lq4av7rE1QleTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-hOwNemexP3mRsdiJLoyPig-1; Wed, 17 Jun 2020 15:41:52 -0400
X-MC-Unique: hOwNemexP3mRsdiJLoyPig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8403A108BD0F;
        Wed, 17 Jun 2020 19:41:51 +0000 (UTC)
Received: from jtoppins.rdu.csb (ovpn-112-156.rdu2.redhat.com [10.10.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 158831001925;
        Wed, 17 Jun 2020 19:41:50 +0000 (UTC)
Reply-To: jtoppins@redhat.com
Subject: Re: [PATCH net] ionic: no link check while resetting queues
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net
References: <20200616011459.30966-1-snelson@pensando.io>
From:   Jonathan Toppins <jtoppins@redhat.com>
Organization: Red Hat
Message-ID: <8fadc381-aa45-8710-fad7-c3cfdb01b802@redhat.com>
Date:   Wed, 17 Jun 2020 15:41:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200616011459.30966-1-snelson@pensando.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/20 9:14 PM, Shannon Nelson wrote:
> If the driver is busy resetting queues after a change in
> MTU or queue parameters, don't bother checking the link,
> wait until the next watchdog cycle.
> 
> Fixes: 987c0871e8ae ("ionic: check for linkup in watchdog")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_lif.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index 9d8c969f21cb..bfadc4934702 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -96,7 +96,8 @@ static void ionic_link_status_check(struct ionic_lif *lif)
>  	u16 link_status;
>  	bool link_up;
>  
> -	if (!test_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state))
> +	if (!test_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state) ||
> +	    test_bit(IONIC_LIF_F_QUEUE_RESET, lif->state))
>  		return;
>  
>  	link_status = le16_to_cpu(lif->info->status.link_status);
> 

Would a firmware reset bit being asserted also cause an issue here
(IONIC_LIF_F_FW_RESET)? Meaning do we need to test for this bit as well?

