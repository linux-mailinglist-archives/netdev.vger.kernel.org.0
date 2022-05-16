Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040EA5293CF
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 00:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349807AbiEPWt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 18:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349808AbiEPWtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 18:49:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CE1E41626
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 15:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652741385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KZhtL4tUlsZFPZEaAEgqkk+4Z8H8nQR6vrRN0bB3kFI=;
        b=F+4VXfN6bZe5KxIG09OTSObh7gVlYlN2Z320AjkXzAV2RvzKr5hJX63qjfg5ISt/NeMQkw
        d5b3XKm9xVJEHgZ30av7Knu1N1g2VvxRDbfUCHJNnBawCaB/IKbmTWvuLhzVA4TIu/kd3f
        ZqvHgsJXCQGYfb4cte8QsBpiw0B2fAw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-O9tZt2feNIWoLqP84GAYlA-1; Mon, 16 May 2022 18:49:41 -0400
X-MC-Unique: O9tZt2feNIWoLqP84GAYlA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA68F811E76;
        Mon, 16 May 2022 22:49:40 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 14F2C154EF1A;
        Mon, 16 May 2022 22:49:36 +0000 (UTC)
Date:   Tue, 17 May 2022 00:49:34 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf 1/4] bpf_trace: check size for overflow in
 bpf_kprobe_multi_link_attach
Message-ID: <20220516224934.GA5013@asgard.redhat.com>
References: <20220516182708.GA29437@asgard.redhat.com>
 <YoLDdaObEQePcIN+@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoLDdaObEQePcIN+@krava>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 11:34:45PM +0200, Jiri Olsa wrote:
> On Mon, May 16, 2022 at 08:27:08PM +0200, Eugene Syromiatnikov wrote:
> > +	if (check_mul_overflow(cnt, sizeof(*syms), &size))
> > +		return -EOVERFLOW;
> 
> there was an update already:
> 
>   0236fec57a15 bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link
> 
> so this won't apply anymore, could you please rebase on top of the latest bpf-next/master?

The issue that this specific check has to go in 4.18, as it covers
possible out-of-bounds write, I'm not sure how to handle it, have
a branch where it is merged manually?

