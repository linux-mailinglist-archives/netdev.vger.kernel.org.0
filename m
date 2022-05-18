Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F1852C3F6
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 22:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242283AbiERUA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242269AbiERUAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:00:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F93F227824
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652904023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aS7gQ5qpFeKUv7/KfR+Cnnmeed9eVIGi0Wg+eyJp4Fg=;
        b=DVKbEtQAoG29VWe0sk6PDmx7z37TsxseOtSv5Tltz5097mwWR6dGgWRqaU97WzOxwUpTA7
        DGAhdpcys3tB5fgjgROKHxtRZr15aSW0rlEo1ZdQ1gW31juGDG0ROgf+/RPJVJKP97R7GE
        WqYwtAdXsJ40SSZCTTo5Hc6clw3G0yU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-HEMs9FENPBm7CP3UBs-DXA-1; Wed, 18 May 2022 16:00:18 -0400
X-MC-Unique: HEMs9FENPBm7CP3UBs-DXA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C54F818019D7;
        Wed, 18 May 2022 20:00:17 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D5051492C14;
        Wed, 18 May 2022 20:00:13 +0000 (UTC)
Date:   Wed, 18 May 2022 22:00:10 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf v3 1/2] bpf_trace: check size for overflow in
 bpf_kprobe_multi_link_attach
Message-ID: <20220518200010.GA29226@asgard.redhat.com>
References: <cover.1652876187.git.esyr@redhat.com>
 <39c4a91f2867684dc51c5395d26cb56ffe9d995d.1652876188.git.esyr@redhat.com>
 <412bf136-6a5b-f442-1e84-778697e2b694@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412bf136-6a5b-f442-1e84-778697e2b694@fb.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 09:34:22AM -0700, Yonghong Song wrote:
> On 5/18/22 5:22 AM, Eugene Syromiatnikov wrote:
> >-	size = cnt * sizeof(*syms);
> >+	if (check_mul_overflow(cnt, (u32)sizeof(*syms), &size))
> >+		return -EOVERFLOW;
> 
> In mm/util.c kvmalloc_node(), we have
> 
>         /* Don't even allow crazy sizes */
>         if (unlikely(size > INT_MAX)) {
>                 WARN_ON_ONCE(!(flags & __GFP_NOWARN));
>                 return NULL;
>         }
> 
> Basically the maximum size to be allocated in INT_MAX.
> 
> Here, we have 'size' as u32, which means if the size is 0xffff0000,
> the check_mul_overflow will return false (no overflow) but
> kvzalloc will still have a warning.
> 
> I think we should change the type of 'size' to be 'int' which
> should catch the above case and be consistent with
> what kvmalloc_node() intends to warn.

Huh, it's a bitmore complicated as check_mul_overflow requires types to
match; what do you think about

+	if (check_mul_overflow(cnt, (u32)sizeof(*syms), &size) || size > INT_MAX)

?

