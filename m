Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C47C6DDA37
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjDKMDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjDKMDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:03:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA6E30ED
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 05:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681214558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zsl3EqzQpOYH+JVTc+1nS7wHRqvd0DNL4VH3/d/TtBM=;
        b=Mw+3XIsS1SScVLlDnVEER+Je+Tzu5iscE4aZoHTCnL0VLSziJsdEMsggU7rd2SReRJ/aHi
        aGeTDL4d6GcEuKrtao6Dt+K11NE+EAhMXU2KsE7uYrcRc6kG1rwZlWC+Us2y/kGETqLyM9
        r3rOih5Z7gClL2hbcMsJcJp+D3HItO0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-qR3hLjzbPhO16mLcvtBGuQ-1; Tue, 11 Apr 2023 08:02:35 -0400
X-MC-Unique: qR3hLjzbPhO16mLcvtBGuQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E710B101A54F;
        Tue, 11 Apr 2023 12:02:34 +0000 (UTC)
Received: from [10.43.2.89] (unknown [10.43.2.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9BC6492C13;
        Tue, 11 Apr 2023 12:02:33 +0000 (UTC)
Message-ID: <9541a779-bca8-4843-23ff-aff47709c5af@redhat.com>
Date:   Tue, 11 Apr 2023 14:02:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] bnxt_en: Allow to set switchdev mode without
 existing VFs
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     mschmidt@redhat.com, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20230406130455.1155362-1-ivecera@redhat.com>
 <258624e7ffa7bfc3960e727c451cdabe4e7f3efe.camel@redhat.com>
Content-Language: en-US
From:   Ivan Vecera <ivecera@redhat.com>
In-Reply-To: <258624e7ffa7bfc3960e727c451cdabe4e7f3efe.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11. 04. 23 12:22, Paolo Abeni wrote:
> On Thu, 2023-04-06 at 15:04 +0200, Ivan Vecera wrote:
>> Remove an inability of bnxt_en driver to set eswitch to switchdev
>> mode without existing VFs by:
>>
>> 1. Allow to set switchdev mode in bnxt_dl_eswitch_mode_set() so
>>     representors are created only when num_vfs > 0 otherwise just
>>     set bp->eswitch_mode
>> 2. Do not automatically change bp->eswitch_mode during
>>     bnxt_vf_reps_create() and bnxt_vf_reps_destroy() calls so
>>     the eswitch mode is managed only by an user by devlink.
>>     Just set temporarily bp->eswitch_mode to legacy to avoid
>>     re-opening of representors during destroy.
>> 3. Create representors in bnxt_sriov_enable() if current eswitch
>>     mode is switchdev one
>>
>> Tested by this sequence:
>> 1. Set PF interface up
>> 2. Set PF's eswitch mode to switchdev
>> 3. Created N VFs
>> 4. Checked that N representors were created
>> 5. Set eswitch mode to legacy
>> 6. Checked that representors were deleted
>> 7. Set eswitch mode back to switchdev
>> 8. Checked that representros were re-created
> 
> Could you please update the commit message and re-post?
> 
> Thanks!

of course..

I.

