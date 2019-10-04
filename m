Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99DF6CB30D
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 03:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbfJDBdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 21:33:13 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46420 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728119AbfJDBdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 21:33:13 -0400
Received: by mail-pg1-f196.google.com with SMTP id a3so2767213pgm.13
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 18:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c2rp60e4sHWRt5YWRGf5XxmkxLR8ESmWxww0FotMbvU=;
        b=llWTnBicHmJQ67OI+SkbAl1Lx5zzDULiubd2y2LGFA1d/3CH+CzYe0wRmhhoweTsB0
         gwKJ7y8Jkjrct1LZ7C77HZa07Q1V0v2hTUoFo8H59blktSJxYiQ4QU+f1I7XsE5UgNxK
         E5ViOilfa2ZmIMck0oSAwe4Akq59DjPgMcODR05LOucNrYFqHvxKSgBdh3FtU2a/Vy5P
         FOc5Z9so55BycCI5qM4znMG284NTgYNZ8lN1hZA7txXnUm27KlQhyNmgBR/WHT4zxQGe
         5TvSxvBujg+YNp4iGjs//xA3yI1ppjjBV4BwCAQhjn18jdBOIny1/YzyTqQcNxa4kngb
         zr2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c2rp60e4sHWRt5YWRGf5XxmkxLR8ESmWxww0FotMbvU=;
        b=ffd0PUcNFEp4XDuquV6ZI5DTm23jTZsqW/P//Lr7dc9dG4Q5CIvZV+rFki254PkLM4
         UNbag0gjR+BLHjCOED2MFcX8ZNmigFB8K+GEawinoLL1lnuLtEFM0pLaa/iegLi3Txlm
         9kLELHf6+e5SAWXMnaHlK4t7+/fdADRL/n6Y8ZoVDUQ4Zh5iiQwV73e86aWY1+azPFur
         N0Cn8yGuwEg2uuJLagk51UAoY2AiF3BZjRE8VUv0ufyYN6ZLoo6SUoD+ufmroh/SLAOm
         xD0kwtbx/ygR4Kxy8RRfc0mRPH41OToUyK+JFyzHLQ2usLDAVElJSEeBwGDrBqCuvRoF
         b2NA==
X-Gm-Message-State: APjAAAX3waJ+fTpFYwi9hQAxgVTGreDr7XKdp/uU3r688eZFGLKoOFv2
        36DedVbVKA0UMW9B6hHflA==
X-Google-Smtp-Source: APXvYqwdEiE+8sGrYHXE22j3oMMoA6b80STDkQMekWuKoYOoTD0J8ESvJt2gPqBsnkWp0CwQiSwg2g==
X-Received: by 2002:a63:4cf:: with SMTP id 198mr12738492pge.105.1570152792265;
        Thu, 03 Oct 2019 18:33:12 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id 127sm4291495pfw.6.2019.10.03.18.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 18:33:11 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [v4 2/4] samples: pktgen: fix proc_cmd command result check logic
Date:   Fri,  4 Oct 2019 10:32:59 +0900
Message-Id: <20191004013301.8686-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191004013301.8686-1-danieltimlee@gmail.com>
References: <20191004013301.8686-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, proc_cmd is used to dispatch command to 'pg_ctrl', 'pg_thread',
'pg_set'. proc_cmd is designed to check command result with grep the
"Result:", but this might fail since this string is only shown in
'pg_thread' and 'pg_set'.

This commit fixes this logic by grep-ing the "Result:" string only when
the command is not for 'pg_ctrl'.

For clarity of an execution flow, 'errexit' flag has been set.

To cleanup pktgen on exit, trap has been added for EXIT signal.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/pktgen/functions.sh | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
index 4af4046d71be..e1865660b033 100644
--- a/samples/pktgen/functions.sh
+++ b/samples/pktgen/functions.sh
@@ -5,6 +5,8 @@
 # Author: Jesper Dangaaard Brouer
 # License: GPL
 
+set -o errexit
+
 ## -- General shell logging cmds --
 function err() {
     local exitcode=$1
@@ -58,6 +60,7 @@ function pg_set() {
 function proc_cmd() {
     local result
     local proc_file=$1
+    local status=0
     # after shift, the remaining args are contained in $@
     shift
     local proc_ctrl=${PROC_DIR}/$proc_file
@@ -73,13 +76,14 @@ function proc_cmd() {
 	echo "cmd: $@ > $proc_ctrl"
     fi
     # Quoting of "$@" is important for space expansion
-    echo "$@" > "$proc_ctrl"
-    local status=$?
-
-    result=$(grep "Result: OK:" $proc_ctrl)
-    # Due to pgctrl, cannot use exit code $? from grep
-    if [[ "$result" == "" ]]; then
-	grep "Result:" $proc_ctrl >&2
+    echo "$@" > "$proc_ctrl" || status=$?
+
+    if [[ "$proc_file" != "pgctrl" ]]; then
+        result=$(grep "Result: OK:" $proc_ctrl) || true
+        # Due to pgctrl, cannot use exit code $? from grep
+        if [[ "$result" == "" ]]; then
+        grep "Result:" $proc_ctrl >&2
+        fi
     fi
     if (( $status != 0 )); then
 	err 5 "Write error($status) occurred cmd: \"$@ > $proc_ctrl\""
@@ -105,6 +109,8 @@ function pgset() {
     fi
 }
 
+trap 'pg_ctrl "reset"' EXIT
+
 ## -- General shell tricks --
 
 function root_check_run_with_sudo() {
-- 
2.20.1

