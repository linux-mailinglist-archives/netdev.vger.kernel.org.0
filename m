Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE0952BB10
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236389AbiERMWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236368AbiERMWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:22:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 843005F8C6
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 05:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652876536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=NfsVd+paNbFCf+lVJNVeNuwNcS/giE10aZS+Eiu/vhg=;
        b=Ev9E7FioHHNtY9gWRM74+QHVbgRvBgXDiwX7+17D5zPrFjLdLvSAsHxKowkubsG6DUhyfj
        DiOJbLYhzeGJvLcVVYAQZGgSJbJcA8KIP4YUe/Nkh1ZYbeAWW8Ar+lbuBA5Ifwp/NaYveg
        3KkaOf4CiD+cJLOyClWKLyc/wY2xRmM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-MZu_C_yEOqOFTCoJoOQEiQ-1; Wed, 18 May 2022 08:22:13 -0400
X-MC-Unique: MZu_C_yEOqOFTCoJoOQEiQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 592CC180138A;
        Wed, 18 May 2022 12:22:12 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 016E51410DD5;
        Wed, 18 May 2022 12:22:08 +0000 (UTC)
Date:   Wed, 18 May 2022 14:22:06 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf v3 0/2] Fix kprobe_multi interface issues for 5.18
Message-ID: <cover.1652876187.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Hello.

While [1] seems to require additional work[2] due to changes
in the interface (and it has already been re-targeted for bpf-next),
I would like to ask to consider the following two patches, that fix
possible out-of-bounds write and properly disable the interface
for 32-bit compat user space, for the 5.18 release.  Thank you.

[1] https://lore.kernel.org/lkml/cover.1652772731.git.esyr@redhat.com/
[2] https://lore.kernel.org/lkml/YoTXiAk1EpZ0rLKE@krava/

Eugene Syromiatnikov (2):
  bpf_trace: check size for overflow in bpf_kprobe_multi_link_attach
  bpf_trace: bail out from bpf_kprobe_multi_link_attach when in compat

 kernel/trace/bpf_trace.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

-- 
2.1.4

