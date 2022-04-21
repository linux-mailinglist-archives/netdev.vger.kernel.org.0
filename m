Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2F0509948
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 09:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385854AbiDUHku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 03:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385972AbiDUHkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 03:40:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C7813E25;
        Thu, 21 Apr 2022 00:36:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F23031F752;
        Thu, 21 Apr 2022 07:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1650526601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q69hhjwT+kSjonv8QFdlTZVMurQeV1T2PIMjNcz8AUM=;
        b=mdjgoTvvaDF2Ag3Zqw5TpPk8QcQaYVhO//4b31iouM4Py+LJ8/mKSsHLid3sdz5izLLiuV
        FJOEjfr3iZbWnFgzUZOrI8zg2EmQlQZ/fZbz0ZYrUz9xd1bM/so3O7+P061vM1FOGZkhUX
        6rX/AoD0+63e10bLXr/B1SvAgvRnF5w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1650526601;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q69hhjwT+kSjonv8QFdlTZVMurQeV1T2PIMjNcz8AUM=;
        b=id70+zebsG7sOnXb7k6LKxwA4b2EWX+tw6TAKsYoO3Nuz8qXpKPs60Q4dMW3heqjNf8wew
        nMDfQuXCV2JR9tBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B535113A84;
        Thu, 21 Apr 2022 07:36:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id D/ZFK4kJYWIwEgAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 21 Apr 2022 07:36:41 +0000
Message-ID: <2683c56f-62c3-987a-72c4-0df5a97368f7@suse.de>
Date:   Thu, 21 Apr 2022 09:36:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH RFC 5/5] net/tls: Add observability for AF_TLSH sockets
Content-Language: en-US
To:     Chuck Lever <chuck.lever@oracle.com>, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
 <165030059773.5073.6168640435213548957.stgit@oracle-102.nfsv4.dev>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <165030059773.5073.6168640435213548957.stgit@oracle-102.nfsv4.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/18/22 18:49, Chuck Lever wrote:
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>   net/tls/af_tlsh.c |   50 +++++++
>   net/tls/trace.c   |    3
>   net/tls/trace.h   |  355 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 402 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
