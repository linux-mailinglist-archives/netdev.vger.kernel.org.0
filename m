Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C206359AC
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236349AbiKWKWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236792AbiKWKUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:20:25 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AF0A458;
        Wed, 23 Nov 2022 02:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tjJZ18LTdt8yGQHIuIh05OVP3GCFhrilaouZa2EqzsE=; b=fofEr0h3K6oMJnSuhxAVTKdOuP
        otSkc3x5LtrdHA4tDbWY/ZPuHmcp5rN3nrSBkhJwyqBwz+cWK369h4rpb6g9CSuQGYNVUB/kTSk+j
        y47DMMaofoHOdLQcdTXcL1MlK+1Z3nhtCCeaSgSAOAqvNcz3BDDycrgm2VEWsu/E6d/Zx0rDOL5Rp
        y2BF1KEi5tO519GJLEFBJPcuwAXsljhyOmH0Fef/Uz/NB2A53/VyyLGgNO0ftD2kfUKUJXh2fp4dh
        U8SXGdUhG/B9e8kIZSPdV1+R/QuFj6yMOUL9kmXwhhsVwhEmmcGDlcW1wmXngN72i1zhRREFp3wzx
        ZeDMEg1Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxmf2-003kSF-ND; Wed, 23 Nov 2022 10:07:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3E40F30034E;
        Wed, 23 Nov 2022 11:07:19 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1F0DD2D819C28; Wed, 23 Nov 2022 11:07:19 +0100 (CET)
Date:   Wed, 23 Nov 2022 11:07:19 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v5 1/5] jump_label: Prevent key->enabled int overflow
Message-ID: <Y33w1z01l9EerNwu@hirez.programming.kicks-ass.net>
References: <20221122185534.308643-1-dima@arista.com>
 <20221122185534.308643-2-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122185534.308643-2-dima@arista.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 06:55:30PM +0000, Dmitry Safonov wrote:

> key->enabled is indeed a ref-counter as it's documented in multiple
> places: top comment in jump_label.h, Documentation/staging/static-keys.rst,
> etc.

> +/***
> + * static_key_fast_inc_not_negative - adds a user for a static key
> + * @key: static key that must be already enabled
> + *
> + * The caller must make sure that the static key can't get disabled while
> + * in this function. It doesn't patch jump labels, only adds a user to
> + * an already enabled static key.
> + *
> + * Returns true if the increment was done.
> + */

One more thing; it might be useful to point out that unlike refcount_t
this thing does not saturate but will fail to increment on overflow.
