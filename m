Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F6110A9E7
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 06:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfK0FVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 00:21:24 -0500
Received: from mail-ua1-f73.google.com ([209.85.222.73]:56500 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfK0FVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 00:21:23 -0500
Received: by mail-ua1-f73.google.com with SMTP id g37so3191478uad.23
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 21:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=mcKuh8s0MTh7jk4/T8rqcssX7rUYavb3lw7AgoJLpH8=;
        b=GH7/IPr0nQn1SgB1JSUVrJyhnO/w3Q5CrbLU9LZhllEaQRteWEq0ksZBTEd1NHGqq3
         doqukcXudrYpb9ZVIsEfBBVIBfABg3/4mGpuaVjwDYqwJWfq3gAcHM0CWyXsx5c5IdKq
         h3vOfmr99QDyk51oSgR0I3LyaqLYuEgb/BaOifnHsbkag+X+DfGy7NAFoG/OVfUiVCQo
         Lu23su+tKPwLCRXOJXA8edOlcHqxzxvogOE0uY6dEmSmp9VwaZBYb/tPVRvQhYTXRB8u
         Tc/Lv1NLyIEzuL4a0Ya59YtbgF/RJFnM8/fzjMWNt3Sl4Eu6zOLn1yQaKieUzh+zsg/p
         FYCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=mcKuh8s0MTh7jk4/T8rqcssX7rUYavb3lw7AgoJLpH8=;
        b=fbIqRdnsFgjiSxuv4Gp6S1ubXLXEd+lu5C8cAjH9r/viFLH1iAL/zFDtFDHaAEAMx3
         mcZhJSmjPYUL+vEN35p60fv101AOvwIW0O27WN3fo6aKu1nlTsElOgFca3jj8eFhzmLw
         tX6869mvbrV6CrQ2unf2i3t5fIQiBQgA4vrj/+t72Fm5MmxeO6ZJyyz9KfcFKq+BrX13
         zue2umzdslj7/Wmk3QIYlZ8DO57YXcy+XNN8obuUh93GeFAEkluWCu6AHZIQdG7VDNer
         KzqZIKwDzPolnWzpzQ1MOrNlfAhdSBmVIWEvPKwc4ppQY8PFFkTmiN2lzrKcZiPJc24Z
         eANA==
X-Gm-Message-State: APjAAAX/zzbRtyo5YtQqamiGtQ4DKikIdPoo65cTCXcfbyWIluZ6lpjp
        YDCkm6ELV1GeDaaQcFqJIo2PP+TLNNz6
X-Google-Smtp-Source: APXvYqxKf6oRO8Nd2/OmQ26jdHfj+fV/1r/GHV397Rqw9EdP+E15fyfDdxxvkgrF+/Wa+MIN+4Ts2IbaNO8y
X-Received: by 2002:a1f:a1ce:: with SMTP id k197mr1593554vke.28.1574832082819;
 Tue, 26 Nov 2019 21:21:22 -0800 (PST)
Date:   Tue, 26 Nov 2019 21:21:18 -0800
Message-Id: <20191127052118.163594-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH iproute2] ss: fix end-of-line printing in misc/ss.c
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Mahesh Bandewar <maheshb@google.com>,
        Maciej Zenczykowski <maze@google.com>, netdev@vger.kernel.org,
        Brian Vazquez <brianvv@google.com>,
        Hritik Vijay <hritikxx8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before commit 5883c6eba517, function field_is_last() was incorrectly
reporting which column was the last because it was missing COL_PROC
and by purely coincidence it was correctly printing the end-of-line and
moving to the first column since the very last field was empty, and
end-of-line was added for the last non-empty token since it was seen as
the last field.

This commits correcrly prints the end-of-line for the last entrien in
the ss command.

Tested:
diff <(./ss.old -nltp) <(misc/ss -nltp)
38c38
< LISTEN    0   128     [::1]:35417   [::]:*   users:(("foo",pid=65254,fd=116))
\ No newline at end of file
---
> LISTEN    0   128     [::1]:35417   [::]:*   users:(("foo",pid=65254,fd=116))

Cc: Hritik Vijay <hritikxx8@gmail.com>
Fixes: 5883c6eba517 ("ss: show header for --processes/-p")
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 misc/ss.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/misc/ss.c b/misc/ss.c
index c58e5c4d..95f1d37a 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -1290,6 +1290,11 @@ static void render(void)
 
 		token = buf_token_next(token);
 	}
+	/* Deal with final end-of-line when the last non-empty field printed
+	 * is not the last field.
+	 */
+	if (line_started)
+		printf("\n");
 
 	buf_free_all();
 	current_field = columns;
-- 
2.24.0.432.g9d3f5f5b63-goog

