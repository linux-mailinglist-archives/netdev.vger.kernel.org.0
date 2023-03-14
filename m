Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A676B9D41
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCNRoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjCNRov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:44:51 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE31BA2C31;
        Tue, 14 Mar 2023 10:44:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 950711F8AE;
        Tue, 14 Mar 2023 17:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678815889; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cX2nEzpfYSvApKcpdljYLZR0H4aXH20MH0UnDHbGbhg=;
        b=TbevLQsnHA7xu8Pu5DG/6wsyYN2/BdK/O7TsTtDRdyRjg/xuIqrIZnIR3ZcT8mQBAsqheO
        7/PLbWmgL3JBn3qLlxzR8HeDbHJGLK0RgsJvMROuPIwYL0H7QDRqz5RmGMU5zj3XxDEogN
        sIzeV7IFWkBn2/j6T8haL2zBBUNrEbI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678815889;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cX2nEzpfYSvApKcpdljYLZR0H4aXH20MH0UnDHbGbhg=;
        b=jyVXnO5vR/fy35nr3D7V05bEu2lD+FLO38hiQ5DKiMbZLKabD6QNZLm4+yg3DjWLcroj0o
        8f0PRKa3FSZEnwAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7A5E913A1B;
        Tue, 14 Mar 2023 17:44:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id j1UzHZGyEGQNEAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Mar 2023 17:44:49 +0000
Message-ID: <f6b53945-bbc2-f6b2-7d70-4f11849af5ce@suse.de>
Date:   Tue, 14 Mar 2023 18:44:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC PATCH 6/9] iscsi: check net namespace for all iscsi lookup
Content-Language: en-US
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
References: <cover.1675876731.git.lduncan@suse.com>
 <cd46fe01cb5710469ffc4a5282c601382360be7d.1675876735.git.lduncan@suse.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <cd46fe01cb5710469ffc4a5282c601382360be7d.1675876735.git.lduncan@suse.com>
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
> All internal lookups of iSCSI transport objects need to be filtered by
> net namespace.
> 
> Signed-off-by: Chris Leech <cleech@redhat.com>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>   drivers/infiniband/ulp/iser/iscsi_iser.c |   5 +-
>   drivers/scsi/be2iscsi/be_iscsi.c         |   4 +-
>   drivers/scsi/bnx2i/bnx2i_iscsi.c         |   4 +-
>   drivers/scsi/cxgbi/libcxgbi.c            |   4 +-
>   drivers/scsi/qedi/qedi_iscsi.c           |   4 +-
>   drivers/scsi/qla4xxx/ql4_os.c            |   8 +-
>   drivers/scsi/scsi_transport_iscsi.c      | 202 ++++++++++++++---------
>   include/scsi/scsi_transport_iscsi.h      |   5 +-
>   8 files changed, 149 insertions(+), 87 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes


