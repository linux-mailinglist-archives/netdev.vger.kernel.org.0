Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D0C6BB5DD
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 15:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbjCOOXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 10:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbjCOOW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 10:22:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873F67C95E;
        Wed, 15 Mar 2023 07:22:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2A4DF211DE;
        Wed, 15 Mar 2023 14:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1678890176; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZXN3JSv2JuNO7QXPyMNGLcsuvXz4zccB7xCl9QvCXx0=;
        b=a4OkV7YgDfYyvZJGSY0wfj0zvUGu55EzMc8yK/Q0mwAoFuHUyv9EOKd588uX0SEm1bAUKI
        XLddUf1uTdVQIWPBvq6FImBmERKh4de/0fu8o3rgjewOTfF0kdlKQYo/WtiGahloJk1YCo
        bWkbRNXnMnMj9kQMCPG92CmBPWloghc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1678890176;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZXN3JSv2JuNO7QXPyMNGLcsuvXz4zccB7xCl9QvCXx0=;
        b=VEP1QR+K19ft2s5XsGNEZFSU2UdJgackjuPRKjrUHdAl9BAKPpvldY3LmIUYjU1wkjcQRh
        Qr45ZukAmKT7UiCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B492813A2F;
        Wed, 15 Mar 2023 14:22:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rxJnK7/UEWTFRgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 15 Mar 2023 14:22:55 +0000
Message-ID: <17007eb9-b831-aabb-78dc-95f4f4aada55@suse.cz>
Date:   Wed, 15 Mar 2023 15:22:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 0/7] remove SLOB and allow kfree() with kmem_cache_alloc()
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
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
        "Paul E. McKenney" <paulmck@kernel.org>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <ZA2gofYkXRcJ8cLA@kernel.org> <20230313123147.6d28c47e@gandalf.local.home>
 <3018fb77-68d0-fb67-2595-7c58c6cf7a76@suse.cz>
 <20230315102031.29585157@gandalf.local.home>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20230315102031.29585157@gandalf.local.home>
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

On 3/15/23 15:20, Steven Rostedt wrote:
> On Wed, 15 Mar 2023 14:53:14 +0100
> Vlastimil Babka <vbabka@suse.cz> wrote:
> 
>> On 3/13/23 17:31, Steven Rostedt wrote:
>> > Just remove that comment. And you could even add:
>> > 
>> > Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
>> > Fixes: e4c2ce82ca27 ("ring_buffer: allocate buffer page pointer")  
>> 
>> Thanks for the analysis. Want to take the following patch to your tree or
>> should I make it part of the series?
> 
> I can take it if you send it as a proper patch and Cc
> linux-trace-kernel@vger.kernel.org.

OK, will do.

> I'm guessing it's not required for stable.

No, but maybe AUTOSEL will pick it anyway as it has Fixes: but that's their
problem ;)

> -- Steve

