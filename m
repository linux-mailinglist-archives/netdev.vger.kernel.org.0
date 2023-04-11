Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1326DD1E4
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 07:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjDKFlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 01:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjDKFlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 01:41:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDAC272B
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 22:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681191618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ciFOiFCvxjc0i9FO+U01KioQUaj++06BDry/0Vmfdz4=;
        b=O0mfuYQwPw9L8VRHtsc5BFmg9j4RWMfnILVtHiJJPBdeQq7IPnoj2lzsWlSbJxK9R50tso
        fjzyV8q8AiraO5x3D+EOUt5NvNnQ8Awp45xiE1QjqgNmoIEyQmxnhc8nNEEmwu9vzzm7VJ
        C2kAQDmqv3J02a3bSwepJQD6mb+p4T4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-lXSyDLFbONuMiwUngB5sZA-1; Tue, 11 Apr 2023 01:40:15 -0400
X-MC-Unique: lXSyDLFbONuMiwUngB5sZA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0C2E8996E7;
        Tue, 11 Apr 2023 05:40:14 +0000 (UTC)
Received: from [10.45.224.115] (unknown [10.45.224.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8E9AC15BA0;
        Tue, 11 Apr 2023 05:40:12 +0000 (UTC)
Message-ID: <78dbf8d2-c13d-a921-bd73-a1361753cb66@redhat.com>
Date:   Tue, 11 Apr 2023 07:40:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] bnxt_en: Allow to set switchdev mode without
 existing VFs
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, mschmidt@redhat.com,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20230406130455.1155362-1-ivecera@redhat.com>
 <20230409090224.GE14869@unreal>
From:   Ivan Vecera <ivecera@redhat.com>
In-Reply-To: <20230409090224.GE14869@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09. 04. 23 11:02, Leon Romanovsky wrote:
> On Thu, Apr 06, 2023 at 03:04:55PM +0200, Ivan Vecera wrote:
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
> Why do you think that this last item is the right behavior?
> IMHO all configurations which were done after you switched mode
> should be cleared and not recreated while toggling.

No, I mean that if I switch back to switchdev mode then representors
should be created again for existing virtual functions not that
representors should be restored with their existing state...
So the point 8 should say:
"8. Checked that representors exist again for VFs"

Ivan

