Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 903FA5856DE
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 00:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239367AbiG2WbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 18:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiG2Wa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 18:30:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB6B2BB19;
        Fri, 29 Jul 2022 15:30:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A61D4B829DA;
        Fri, 29 Jul 2022 22:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FFFC433D6;
        Fri, 29 Jul 2022 22:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659133855;
        bh=L99nrOz0sOglljuGihJFxiAQVZKNS3MgPeVmrXowoVw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=L9GhQYV8A3+t5rNpM67VQWjY//MnPcOaqesyri44DTsf+HZ/CAGnCSKgNad/RI1vm
         kXN21xlUTzou6XlfxAEtYSWyxkgJElYUWLvlNVZ+cChvEruuRaFwZjv76S4pbmu7l1
         wSDbovunqVMehYA4Wst0254gv2SrxgErgqRjy3bC442iNf2uFPGj+SRAGbVKPMqzbR
         FTVP55b6WOo/YozZVCT1aHyp6UCjaVUmRrNciSzOx2RLzwhhCp+YfMVp/EfGNSTw2a
         ydvJItwZNEIngS+chGG6Mef1/HD7FyRiyGqcnqWVIhiQkfKDoVs9wzuO+Yguz52Gtt
         hS9CYZgyVUd/w==
Message-ID: <c15eadde-bdbe-915f-7bc5-9ccee345f27b@kernel.org>
Date:   Fri, 29 Jul 2022 16:30:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4 00/27] io_uring zerocopy send
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1657194434.git.asml.silence@gmail.com>
 <2c49d634-bd8a-5a7f-0f66-65dba22bae0d@kernel.org>
 <bd9960ab-c9d8-8e5d-c347-8049cdf5708a@gmail.com>
 <0f54508f-e819-e367-84c2-7aa0d7767097@gmail.com>
 <d10f20a9-851a-33be-2615-a57ab92aca90@kernel.org>
 <bc48e2bb-37ee-5b7c-5a97-01e026de2ba4@gmail.com>
 <812c3233-1b64-8a0d-f820-26b98ff6642d@kernel.org>
 <3b81b3e1-2810-5125-f4a0-d6ba45c1fbd3@kernel.org>
 <0a3b7166-5f86-f808-e26d-67966bd521fe@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <0a3b7166-5f86-f808-e26d-67966bd521fe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/22 4:51 AM, Pavel Begunkov wrote:
>> With your zc_v5 branch (plus the init fix on using msg->sg_from_iter),
>> iperf3 with io_uring support (non-ZC case) no longer shows completions
>> with incomplete sends. So that is good improvement over the last time I
>> tried it.
>>
>> However, adding in the ZC support and that problem resurfaces - a lot of
>> completions are for an incomplete size.
> 
> Makes sense, it explicitly retries with normal sends but I didn't
> implement it for zc. Might be a good thing to add.
> 

Yes, before this goes it. It will be confusing to users to get
incomplete completions when using the ZC option.
