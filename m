Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 518A9CC8C0
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 10:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfJEIZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 04:25:24 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38197 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfJEIZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 04:25:23 -0400
Received: by mail-pf1-f193.google.com with SMTP id h195so5340757pfe.5
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 01:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3n6oBPP8THr+Q5q143x/UKX/r66TtV/GuGpDebRbkXE=;
        b=WltONObssCFpsOrpe1F88q708A58GGcS+XN7+Rx2AmJ45rkli5t5S48MtqVU6393hi
         nNIEcB99w5rdWImjKpqW4T8A9NxPhhcLEJy0FayVIAOoltcz2TaQLwyANyBOyefq0cWK
         WB+jr707xRtAsKiDx/vwz89C/fSs0KP3QTvCNgrpxTCJ/u1qmWJekmpF9Wpv+PCOGGxo
         jK0d3HaPa6KSWOS9cjwWgQIQ1xKuVkV3h9NculQ0TUA089pk4uup1mPwvMagGkruwOD+
         V9bebsJdc2090FSintrqgKrnB5Jxx1RrLuNs4cPT0rZR/sHHCuc1K2BKFja8n+ADj+2Q
         KN7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3n6oBPP8THr+Q5q143x/UKX/r66TtV/GuGpDebRbkXE=;
        b=VLSB0vjBaWXZIm5NLGCKQmUPnQ6IlgBq5/lfzuiGo1RK9ah50edC5FhFSVdq4qyLoF
         tLUpxTd1gRh70XP+gV9Z+A0l4/UeLen4u2Ue8Oug1Re+zhBO0xRiFb3gY/4kMKnx9+Uw
         rJjX2WAzFhrnB76iSPCxGi06rUZDjyKCLTdWF4MSb1o13xb6q3gZtnbwY83QtbpF/D7j
         QJGlipYHz//RzxHGUd3TSFzLajRRLDp8cHTK/FzPYdZrjKZ7fR7UoxRKgwdu2u2poJjh
         fakotIKIWsG4ZiqUamjtd6kswx0kojEgSnaK7ibutrDfxwz2Jb7zIIdQsUrU0nSjdj7t
         HaBQ==
X-Gm-Message-State: APjAAAWrZ2sYiV9vTiGa9ZO7Yg/Vq+VWi3w3E0eAinOJgh1C8L8Pt+CL
        gyBkGOmnpepT64/zjxis0out2NV1W6Bq
X-Google-Smtp-Source: APXvYqx3YQiK2kbQwNjIZ1yeJzoY/mFfQUqih0VYVE3mcHhQ0Ziua7Ea641PKxjF6PVFGpl5akPYsA==
X-Received: by 2002:a63:4924:: with SMTP id w36mr20078314pga.113.1570263923067;
        Sat, 05 Oct 2019 01:25:23 -0700 (PDT)
Received: from localhost.localdomain ([106.254.212.20])
        by smtp.gmail.com with ESMTPSA id dw19sm7161838pjb.27.2019.10.05.01.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 01:25:22 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v5 2/4] samples: pktgen: fix proc_cmd command result check logic
Date:   Sat,  5 Oct 2019 17:25:07 +0900
Message-Id: <20191005082509.16137-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191005082509.16137-1-danieltimlee@gmail.com>
References: <20191005082509.16137-1-danieltimlee@gmail.com>
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
Changes since v5:
 * when script runs sudo, run 'pg_ctrl "reset"' on EXIT with trap

 samples/pktgen/functions.sh | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
index 4af4046d71be..40873a5d1461 100644
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
@@ -73,13 +76,13 @@ function proc_cmd() {
 	echo "cmd: $@ > $proc_ctrl"
     fi
     # Quoting of "$@" is important for space expansion
-    echo "$@" > "$proc_ctrl"
-    local status=$?
+    echo "$@" > "$proc_ctrl" || status=$?
 
-    result=$(grep "Result: OK:" $proc_ctrl)
-    # Due to pgctrl, cannot use exit code $? from grep
-    if [[ "$result" == "" ]]; then
-	grep "Result:" $proc_ctrl >&2
+    if [[ "$proc_file" != "pgctrl" ]]; then
+        result=$(grep "Result: OK:" $proc_ctrl) || true
+        if [[ "$result" == "" ]]; then
+            grep "Result:" $proc_ctrl >&2
+        fi
     fi
     if (( $status != 0 )); then
 	err 5 "Write error($status) occurred cmd: \"$@ > $proc_ctrl\""
@@ -105,6 +108,8 @@ function pgset() {
     fi
 }
 
+[[ $EUID -eq 0 ]] && trap 'pg_ctrl "reset"' EXIT
+
 ## -- General shell tricks --
 
 function root_check_run_with_sudo() {
-- 
2.20.1

