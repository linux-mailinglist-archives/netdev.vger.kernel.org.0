Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7AF6BB4E3
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbjCONkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbjCONk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:40:29 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A4C7D89;
        Wed, 15 Mar 2023 06:40:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E7B691FD76;
        Wed, 15 Mar 2023 13:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1678887617; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JDMwZnj0jpzJKMut3O94VkQeRgqjxGWKZ5FCPetUts8=;
        b=BjaXSNRMbW7UVWsqkIPQS48AvhzPCz0KmnAAWTpY7yjhSJ+yzG6bUUvO6aoLUrqEjn61J8
        IZcnP7fGpe+cQI5ARDl91zXTmYOJg9ceBhTh3fjh2K76V/NgD9G8gTPzN5vh5SXy/TG8ej
        rs3/DiNfMsFKgXCgGkzdb5MlwUaF23M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1678887617;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JDMwZnj0jpzJKMut3O94VkQeRgqjxGWKZ5FCPetUts8=;
        b=MXJhsVmRLm74iRenhRKigv2/GAwervP22DuCtg6PX8YkAPaj3QnYIqB5MVoR+ubFrsUbgw
        1D7r4yTOJ7q4ndDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 625DE13A2F;
        Wed, 15 Mar 2023 13:40:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gnM+F8HKEWTjLwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 15 Mar 2023 13:40:17 +0000
Message-ID: <be3635be-7602-c179-8c44-f4486d7305fe@suse.cz>
Date:   Wed, 15 Mar 2023 14:40:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 0/7] remove SLOB and allow kfree() with kmem_cache_alloc()
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     Mike Rapoport <mike.rapoport@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mike Rapoport <rppt@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <ZA2gofYkXRcJ8cLA@kernel.org> <93d33f35-fc5e-3ab2-1ac0-891f018b4b06@suse.cz>
 <eeb8c896-120f-482f-97c0-0cff22a53e0f@lucifer.local>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <eeb8c896-120f-482f-97c0-0cff22a53e0f@lucifer.local>
Content-Type: text/plain; charset=UTF-8
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

On 3/14/23 23:10, Lorenzo Stoakes wrote:
> On Mon, Mar 13, 2023 at 05:36:44PM +0100, Vlastimil Babka wrote:
>> > git grep -in slob still gives a couple of matches. I've dropped the
>> > irrelevant ones it it left me with these:
> 
> I see an #ifdef in security/tomoyo/common.h which I guess is not really
> relevant? And certainly not harmful in practice. Thought might be nice to
> eliminate the last reference to CONFIG_SLOB in the kernel :)

Yeah I wrote in the cover letter the tomoyo change is already going through
tomoyo tree. And based on Jakub's feedback the skbuff change will be also
posted separately.
