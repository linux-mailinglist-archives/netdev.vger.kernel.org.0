Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BF622B121
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgGWOT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 10:19:28 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45350 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726982AbgGWOT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 10:19:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595513966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=TPxJ6ecRZcUkmgqLd9QvSwuf9V9UOaIvEHGPITh1SwI=;
        b=VWAuYbDKvbf6ismsN/4I9KJXw8OFLzhVTaP+YI59Y3yI9T565CHszyxmnyIj5WOjwsWtZn
        eEakjIUtfHIy6MVMv/Xy9dmPkcSQUkkhX6jguCnqujLfE1iRM/e0bGSMR1dZFEeYyVztMu
        YDQRYsf684E3rNoU8rj39V3drjMYYLk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-adBTiQ3CNtW23DzNlsP3hQ-1; Thu, 23 Jul 2020 10:19:25 -0400
X-MC-Unique: adBTiQ3CNtW23DzNlsP3hQ-1
Received: by mail-qt1-f197.google.com with SMTP id q7so3744946qtq.14
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 07:19:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TPxJ6ecRZcUkmgqLd9QvSwuf9V9UOaIvEHGPITh1SwI=;
        b=XeCv9u7euVfOu7xoksrS9zYjMT/Roxsrygi1LAEhJoM4JBSXFaPD31IZHfgyeHm24c
         uJEgrnL8X2xjhfh5Q7bI5HiQBS6aKhiH0rjkF4GYEnt/pJRqLU1aQO278A0wKM03hD1y
         e0U4kekyfVlfDfUfJYdb9dqq7SPJESFguIc2dhEXF3QsOaBmeuNtkP3ygJRtEK3RV7CN
         lXD1axdcRw31Mae88dZDAJ4ScAQ93zzofQ5BPzBH9ex1lUqH9MKOfP5oiifj9kzLo5H1
         BbuEDNSq9NsfsV+dnT6mFi9aVoA9FUqFJ6DJYB+1pBN0O1sk72eSPwPZLo8orkOwzKQH
         871A==
X-Gm-Message-State: AOAM531625KJzCkcdjCis5+fQhf0a/PAIw9cTZMv9znL02dublDfXEgg
        pULaxBMsWWDk5jXQ+ZAgBa3q7ZuQCXLfasKliPB5qdiD7al8ssAvRjU4keFqPF2ACnbIN03ElQS
        FwAYn1Y9wGUkL3qSF
X-Received: by 2002:ae9:dd41:: with SMTP id r62mr5425020qkf.327.1595513964214;
        Thu, 23 Jul 2020 07:19:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyor/sEuJ1ILiUvnXH2q/LutcM92n90ckKA+iXLKs3Ks/I7zdfJPzXs5YbSaHWhsPNDMTwjrA==
X-Received: by 2002:ae9:dd41:: with SMTP id r62mr5424974qkf.327.1595513963870;
        Thu, 23 Jul 2020 07:19:23 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id j9sm2626609qtr.60.2020.07.23.07.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 07:19:23 -0700 (PDT)
From:   trix@redhat.com
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        masahiroy@kernel.org, mhiramat@kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, will@kernel.org, krzk@kernel.org,
        patrick.bellasi@arm.com, dhowells@redhat.com,
        ebiederm@xmission.com, hannes@cmpxchg.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] bpf: BPF_SYSCALL depends INET
Date:   Thu, 23 Jul 2020 07:19:14 -0700
Message-Id: <20200723141914.20722-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A link error

kernel/bpf/net_namespace.o: In function `bpf_netns_link_release':
net_namespace.c: undefined reference to `bpf_sk_lookup_enabled'

bpf_sk_lookup_enabled is defined with INET
net_namespace is controlled by BPF_SYSCALL

So add a depends on INET to BPF_SYSCALL

Signed-off-by: Tom Rix <trix@redhat.com>
---
 init/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index 7b8ef43e7fb4..817f70e6023c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1663,6 +1663,7 @@ config BPF_SYSCALL
 	bool "Enable bpf() system call"
 	select BPF
 	select IRQ_WORK
+	depends on INET
 	default n
 	help
 	  Enable the bpf() system call that allows to manipulate eBPF
-- 
2.18.1

