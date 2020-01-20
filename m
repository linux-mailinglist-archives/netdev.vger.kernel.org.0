Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035E9142B83
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 14:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgATNGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 08:06:51 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31039 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728767AbgATNGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 08:06:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579525609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oVICxkwYE819T09jumS9b6kqZZVW9alGabNhw2Byv4c=;
        b=f0lZc68RzWNGup775p3zEzxxDBqWTPRU1wSjicbNzpMULAOnlAfHXwsFjolz6DD9g6K9vO
        jpoS2qr+RaaMY9bKOUrL8qBh5pwZTXf/XGqp3+4kZfx4pfHb6zYIZWU3wpEjUfZaFesahp
        oWNfHBX2c/SGnxyvkc0E9W5e6ia2gk0=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-TS2fM96gMZGVhC40in-JUw-1; Mon, 20 Jan 2020 08:06:44 -0500
X-MC-Unique: TS2fM96gMZGVhC40in-JUw-1
Received: by mail-lf1-f72.google.com with SMTP id t8so6207018lfc.21
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 05:06:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=oVICxkwYE819T09jumS9b6kqZZVW9alGabNhw2Byv4c=;
        b=Uzk0t4mlefQfWZG7LMowPJ31pUslgBz2RcQbctS0voyovKEDl+dsSnGQNIIhWv+ME/
         pj6H7GX2aA2SpZ+Amx9xqC0zXepZGz9s8uJ8kGWEhILpHYAnI5btnfjph1Yp3ofKHULI
         O1X7pKigfwbUj/psmRBV7YJ4t3v86aNm/1xfet4vMe+rsTKq6m86Ovqf9G3RF+vfKpd6
         tdBI6fqz6ZdArfbxThQ3doXWoZQz3Y8gxNa3apipFR6WhmDITZNEqL865HydJ6iyy1Dt
         e8/qtq4GF4V5Q3tsS4nzTH/eu4RShcGhELgmLJsLh7nP7UcStOb/WHOcvwX9P7Pzum8J
         nrEg==
X-Gm-Message-State: APjAAAWbvBIj3RiY3hnfIaZy/oKvQ9rcBcoH8MFejtXMpJDXGouemF+A
        0qtDrZ5o6gfqOPWqM6fOsPLWrFVTJDRzFlphBXBzGoX2GtTi0KAzZl0smsnVjlHcIfi40KUCBrI
        P7bZuvJLeBGD15oG1
X-Received: by 2002:a2e:9015:: with SMTP id h21mr13901680ljg.69.1579525603442;
        Mon, 20 Jan 2020 05:06:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqxl6cjsyjw8Scl4Npe4TQQoKpYIFE7qfthL3twnuQzv1KZL4kmSTEjNXwjKvkvlIou0OEBbwA==
X-Received: by 2002:a2e:9015:: with SMTP id h21mr13901661ljg.69.1579525603114;
        Mon, 20 Jan 2020 05:06:43 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z5sm16825740lji.40.2020.01.20.05.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 05:06:42 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 59E971804D7; Mon, 20 Jan 2020 14:06:41 +0100 (CET)
Subject: [PATCH bpf-next v5 01/11] samples/bpf: Don't try to remove user's
 homedir on clean
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Mon, 20 Jan 2020 14:06:41 +0100
Message-ID: <157952560126.1683545.7273054725976032511.stgit@toke.dk>
In-Reply-To: <157952560001.1683545.16757917515390545122.stgit@toke.dk>
References: <157952560001.1683545.16757917515390545122.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The 'clean' rule in the samples/bpf Makefile tries to remove backup
files (ending in ~). However, if no such files exist, it will instead try
to remove the user's home directory. While the attempt is mostly harmless,
it does lead to a somewhat scary warning like this:

rm: cannot remove '~': Is a directory

Fix this by using find instead of shell expansion to locate any actual
backup files that need to be removed.

Fixes: b62a796c109c ("samples/bpf: allow make to be run from samples/bpf/ directory")
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 samples/bpf/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 5b89c0370f33..f86d713a17a5 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -254,7 +254,7 @@ all:
 
 clean:
 	$(MAKE) -C ../../ M=$(CURDIR) clean
-	@rm -f *~
+	@find $(CURDIR) -type f -name '*~' -delete
 
 $(LIBBPF): FORCE
 # Fix up variables inherited from Kbuild that tools/ build system won't like

