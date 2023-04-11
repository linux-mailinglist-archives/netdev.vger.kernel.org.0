Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CFA6DD2AF
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 08:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjDKGV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 02:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjDKGVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 02:21:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D61172E;
        Mon, 10 Apr 2023 23:21:24 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4470921A4A;
        Tue, 11 Apr 2023 06:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681194083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2kwn18c/T+2wAfn5ja1T55ELVX775A8gqjuoiOsgh18=;
        b=JR6wPiYGlzZo3ktdch7gn+E7BMkftmp9vpyMAhf13x8y4ZGfpNqDUU/yNA4eCT0Mgv3utk
        WMx1+WYiPG1VooP6y/eCM0Y1DhARRRCRfZFdkEn49E+pBjzCSC/9x2mlVOfC2q0qq/2i88
        fGFwE6F+puGuBFL/RL60PwQPOSPSnOM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681194083;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2kwn18c/T+2wAfn5ja1T55ELVX775A8gqjuoiOsgh18=;
        b=q1iS8gMtefC9VVRVVlfm0GGASYe+PPs7pBAPxd92Aj2c5O3Zey7nZiUMKBpLthEp3zY4++
        QPDbik+x4AM+hqAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2001413519;
        Tue, 11 Apr 2023 06:21:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TBqlBmP8NGTMSQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 06:21:23 +0000
Message-ID: <85458436-702f-2e38-c7cc-ff7329731eda@suse.de>
Date:   Tue, 11 Apr 2023 08:21:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 11/11] iscsi: force destroy sesions when a network
 namespace exits
Content-Language: en-US
To:     Chris Leech <cleech@redhat.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, Lee Duncan <leeman.duncan@gmail.com>,
        netdev@vger.kernel.org
References: <83de4002-6846-2f90-7848-ef477f0b0fe5@suse.de>
 <20230410191033.1069293-3-cleech@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230410191033.1069293-3-cleech@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/23 21:10, Chris Leech wrote:
> The namespace is gone, so there is no userspace to clean up.
> Force close all the sessions.
> 
> This should be enough for software transports, there's no implementation
> of migrating physical iSCSI hosts between network namespaces currently.
> 
Ah, you shouldn't have mentioned that.
(Not quite sure how being namespace-aware relates to migration, though.)
We should be checking/modifying the iSCSI offload drivers, too.
But maybe with a later patch.

> Signed-off-by: Chris Leech <cleech@redhat.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

