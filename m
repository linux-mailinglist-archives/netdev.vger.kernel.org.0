Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E111F6B9D57
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjCNRrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCNRrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:47:07 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF74A590B;
        Tue, 14 Mar 2023 10:47:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 915BD21A81;
        Tue, 14 Mar 2023 17:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678816025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kQCwPppQzHLY//VQWuDUSTxSBPKu74YPyDD8dbAyBQQ=;
        b=krIguMSrXX80qLPU0vJTTvN1ciL+m45qF1n2p1JNBQg86gYKgN+6mUrF3qUsLF1fdGJ77Z
        nYDIYP/MLgWTmd6d+hdB3ooPQFNIr83/Gs0rw0TdS0+dCC2aNyhgy4n5Y7rOALsr6wSEkR
        o41UWwwvXc3bX4tX4QXdEOnOhZTwPM4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678816025;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kQCwPppQzHLY//VQWuDUSTxSBPKu74YPyDD8dbAyBQQ=;
        b=s1M4ZmZmtr9xkyXiVbkxO1SZHXrI9VL2RILtI5+9klR6E6QddAm9T0evXvxKUqUZPsaYmk
        F+noMT8Y9ZrWPSDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6F60813A1B;
        Tue, 14 Mar 2023 17:47:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 89lmGhmzEGRYEQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Mar 2023 17:47:05 +0000
Message-ID: <2f6cadce-3680-f80c-7016-5300e9b2ff9a@suse.de>
Date:   Tue, 14 Mar 2023 18:47:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC PATCH 9/9] iscsi: filter flashnode sysfs by net namespace
Content-Language: en-US
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
References: <cover.1675876731.git.lduncan@suse.com>
 <283ecc31424b7f5e8e3dd68aa2283fcd109de145.1675876736.git.lduncan@suse.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <283ecc31424b7f5e8e3dd68aa2283fcd109de145.1675876736.git.lduncan@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/23 18:40, Lee Duncan wrote:
> From: Lee Duncan <lduncan@suse.com>
> 
> This finishes the net namespace support for flashnode sysfs devices.
> 
> Signed-off-by: Chris Leech <cleech@redhat.com>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 34 +++++++++++++++++++++++++++++
>   include/scsi/scsi_transport_iscsi.h |  4 ----
>   2 files changed, 34 insertions(+), 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes


