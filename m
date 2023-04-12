Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECEB6DEB7D
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 08:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjDLGCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 02:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLGCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 02:02:49 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA5B3A98;
        Tue, 11 Apr 2023 23:02:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0B88121940;
        Wed, 12 Apr 2023 06:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681279367; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2jv6U/y14eRDx1QvxhnepcCCOP5Pg57H1mqamrdIt/s=;
        b=GUG5Y9eycnzhJMcYuE+SWH3QXzOIx/08kORfa7fBhRI9Nbkz0tHUq/LzZ3bhaihwCsC3eL
        R2VRPRb+zSxMVWjgenEO8T5Y4s/UIyqy7koTBsOB6Vd8Df0I5f/ow0er4a/i502TzDHqk+
        eqngERR5ZFd0srHeAoorsapliAp2T6E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681279367;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2jv6U/y14eRDx1QvxhnepcCCOP5Pg57H1mqamrdIt/s=;
        b=fldrXYHH4IYycwrzOAGS/EXNvzk1THQOiDQrBKkznlfg6ObrLrQKNQq3mhjZmUFTIeX2DQ
        yyoeTVxZqNktKOCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B0B96132C7;
        Wed, 12 Apr 2023 06:02:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RqxpIoZJNmT5DgAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 12 Apr 2023 06:02:46 +0000
Message-ID: <e7b55e2d-4bd1-eabe-43b6-ef00da69935a@suse.de>
Date:   Wed, 12 Apr 2023 08:02:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 11/11] iscsi: force destroy sesions when a network
 namespace exits
Content-Language: en-US
To:     linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        Lee Duncan <leeman.duncan@gmail.com>, netdev@vger.kernel.org
References: <83de4002-6846-2f90-7848-ef477f0b0fe5@suse.de>
 <20230410191033.1069293-3-cleech@redhat.com>
 <85458436-702f-2e38-c7cc-ff7329731eda@suse.de>
 <20230411181945.GB1234639@localhost>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230411181945.GB1234639@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/23 20:19, Chris Leech wrote:
> On Tue, Apr 11, 2023 at 08:21:22AM +0200, Hannes Reinecke wrote:
>> On 4/10/23 21:10, Chris Leech wrote:
>>> The namespace is gone, so there is no userspace to clean up.
>>> Force close all the sessions.
>>>
>>> This should be enough for software transports, there's no implementation
>>> of migrating physical iSCSI hosts between network namespaces currently.
>>>
>> Ah, you shouldn't have mentioned that.
>> (Not quite sure how being namespace-aware relates to migration, though.)
>> We should be checking/modifying the iSCSI offload drivers, too.
>> But maybe with a later patch.
> 
> I shouldn't have left that opening ;-)
> 
> The idea with this design is to keep everything rooted on the
> iscsi_host, and for physical HBAs those stay assigned to init_net.
> With this patch set, offload drivers remain unusable in a net namespace
> other than init_net. They simply are not visible.
> 
> By migration, I was implying the possibilty of assigment of an HBA
> iscsi_host into a namespace like you can do with a network interface.
> Such an iscsi_host would then need to be migrated back to init_net on
> namespace exit.
> 
> I don't think it works to try and share an iscsi_host across namespaces,
> and manage different sessions. The iSCSI HBAs have a limited number of
> network configurations, exposed as iscsi_iface objects, and I don't want
> to go down the road of figuring out how to share those.
> 
Ah, yes, indeed.

Quite some iSCSI offloads create the network session internally (or 
don't even have one), so making them namespace aware will be tricky.

But then I guess we should avoid creating offload sessions from other 
namespaces; preferably by a patch for the kernel such that userspace can 
run unmodified.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

