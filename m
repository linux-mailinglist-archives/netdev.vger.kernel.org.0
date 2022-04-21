Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99F450A723
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 19:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390792AbiDURcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 13:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390788AbiDURcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 13:32:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F205248898
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 10:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650562164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e9DZ+W1tXa8dFqgf2097OZ0qGTRPNdwwslU5YUVe0Xk=;
        b=dxWwJxchc47py0hes9iudp8MMP/VN11MnJGIVVcxjlOyFgqdJNJaTK1Rm7Kr9ybDdn8M3J
        XE15DOL2S9Y6ahT5QCPIXKjH3YwMeQ8935khmjdfWgIpigZiewTSFpL70Vks5oUlQe5aAz
        ASEeil8GD1nUgxeAUK2B704B6kRoH/I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-tnkI7wWFPTSa6b_M4Jj5jw-1; Thu, 21 Apr 2022 13:29:18 -0400
X-MC-Unique: tnkI7wWFPTSa6b_M4Jj5jw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1358C800B28;
        Thu, 21 Apr 2022 17:29:18 +0000 (UTC)
Received: from sparkplug.usersys.redhat.com (unknown [10.40.192.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FAE29D61;
        Thu, 21 Apr 2022 17:29:16 +0000 (UTC)
Date:   Thu, 21 Apr 2022 19:29:13 +0200
From:   Artem Savkov <asavkov@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next] selftests/bpf: fix prog_tests/uprobe_autoattach
 compilation error
Message-ID: <YmGUaXfBywiSQ+Sy@sparkplug.usersys.redhat.com>
References: <20220421132317.1583867-1-asavkov@redhat.com>
 <e5919342-0697-65f0-063f-4941e74fe1ca@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e5919342-0697-65f0-063f-4941e74fe1ca@iogearbox.net>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 06:53:22PM +0200, Daniel Borkmann wrote:
> On 4/21/22 3:23 PM, Artem Savkov wrote:
> > I am getting the following compilation error for prog_tests/uprobe_autoattach.c
> > 
> > tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c: In function ‘test_uprobe_autoattach’:
> > ./test_progs.h:209:26: error: pointer ‘mem’ may be used after ‘free’ [-Werror=use-after-free]
> > 
> > mem variable is now used in one of the asserts so it shouldn't be freed right
> > away. Move free(mem) after the assert block.
> 
> Looks good, but I rephrased this a bit to avoid confusion. It's false positive given we
> only compare the addresses but don't deref mem, which the compiler might not be able to
> follow in this case.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=6a12b8e20d7e72386594a9dbe7bf2d7fae3b3aa6

Right. Thank you for fixing up the commit message.

-- 
 Artem

