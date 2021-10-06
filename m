Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B46423D40
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 13:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238548AbhJFLuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 07:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238345AbhJFLt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 07:49:56 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC59C061767;
        Wed,  6 Oct 2021 04:48:01 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id b8so8904935edk.2;
        Wed, 06 Oct 2021 04:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V+ouzVHY1tKwbsTAOsFU9MaQhJWVSywu54+Kl5C21BA=;
        b=RheMnFUJ3nYggT0gxdozsswRrB0j0CyuGqs1KUrfgo1fN1F3kxviqwOWgxANxjSpFl
         G8ml1ecv9xYq3qgbMc5wBseV3wPN3r7Z7NA/n3Hjq5mPZV7gqKY/uLN76z8AXSvNg8J2
         MpQByNysZwe1cRQnAjJDRd9qIsjMQX3D8RmakRsQrkP4BshcX/rklab/M8e6hXUUoVsd
         5qKZ72Nxck+UX25qZWVmFB5vXZM8LHk3cvT1M4EV8GYCPesIKYD7KV7Mz3lIBMDvBhfs
         k5QoXvKnN1YUFdJvsDRSwqZEV9RhKIYl0gMUGQCd1EDWCVHnxGESCnyKRZkuwT2QKdkM
         jmxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V+ouzVHY1tKwbsTAOsFU9MaQhJWVSywu54+Kl5C21BA=;
        b=Kf5TistojRKe/CTM7FzqSIDU6X6lVyNUunijjiEbTJVy6MT5mYB7RFTsGnVILK1G5Y
         yygqdiBL3CHlKCTOKmTIa9phIQwoPLUUkNCEj/9oxinYm18jPfxhY3OxTXhs/IJ9jed3
         m5NkQteKtiTDZtZQqATANCyeSxSnVurH4XwBFJpNNMt8Thn6zJGhKCAhmkWhu0fHvk9r
         /4SsZHNpYTLL7Llia8G6tELiyGQcMy84bxcJqV/PYhQTUTmnRUz7Tsuz5VTQHIjfujAp
         7L4HJds3R+acAEAQpVEOP8VVFhGz+h/Zp23fojJhzJS967an3HlL3LT2IEaLzutC+Wgk
         LZ4g==
X-Gm-Message-State: AOAM530VLy+6NoqOxlUH4p1CbxT55dgvJOn44xAM0/iWX2lF6xbE7tl2
        MxTw/UDfbylTopNvPEOYou8=
X-Google-Smtp-Source: ABdhPJy2m44sIK+eTQjGftlZctPgjwjgMX+E2x3LdMbcnj+3UrZBE1BhNq69uAgLI6qobd8SSNobdQ==
X-Received: by 2002:a50:bf08:: with SMTP id f8mr32548383edk.400.1633520880040;
        Wed, 06 Oct 2021 04:48:00 -0700 (PDT)
Received: from localhost.localdomain ([95.76.3.69])
        by smtp.gmail.com with ESMTPSA id y40sm1402187ede.31.2021.10.06.04.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 04:47:59 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] selftests: nettest: Implement -k to fork after bind or listen
Date:   Wed,  6 Oct 2021 14:47:23 +0300
Message-Id: <6c035c083cedd0ccf06932344d33c867763d6762.1633520807.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633520807.git.cdleonard@gmail.com>
References: <cover.1633520807.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fcnal-test.sh script launches the nettest server in the background
and sleeps for 1 second to ensure that it has time to get up.

Add an option to nettest to fork into the background as soon as packets
are accepted by the kernel, this means bind() for datagrams or listen()
for TCP.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 34 ++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index bd6288302094..576d8bb4c94c 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -73,10 +73,11 @@ struct sock_args {
 	unsigned int has_local_ip:1,
 		     has_remote_ip:1,
 		     has_grp:1,
 		     has_expected_laddr:1,
 		     has_expected_raddr:1,
+		     fork_background:1,
 		     bind_test_only:1;
 
 	unsigned short port;
 
 	int type;      /* DGRAM, STREAM, RAW */
@@ -1388,10 +1389,29 @@ static int config_xfrm_policy(int sd, struct sock_args *args)
 	}
 
 	return 0;
 }
 
+static void handle_fork_background(struct sock_args *args)
+{
+	pid_t fork_result;
+	int result;
+
+	if (!args->fork_background)
+		return;
+
+	fork_result = fork();
+	if (fork_result)
+		exit(0);
+	result = setpgid(0, 0);
+	if (result) {
+		log_err_errno("Failed setpgid");
+		exit(1);
+	}
+	log_msg("server running in background\n");
+}
+
 static int lsock_init(struct sock_args *args)
 {
 	long flags;
 	int sd;
 
@@ -1422,10 +1442,12 @@ static int lsock_init(struct sock_args *args)
 	if (args->type == SOCK_STREAM && listen(sd, 1) < 0) {
 		log_err_errno("listen failed");
 		goto err;
 	}
 
+	handle_fork_background(args);
+
 	flags = fcntl(sd, F_GETFL);
 	if ((flags < 0) || (fcntl(sd, F_SETFL, flags|O_NONBLOCK) < 0)) {
 		log_err_errno("Failed to set non-blocking option");
 		goto err;
 	}
@@ -1819,11 +1841,11 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 
 	wait(&status);
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6xL:0:1:2:3:Fbq"
+#define GETOPT_STR  "sr:l:c:p:t:g:P:DRn:M:X:m:d:I:BN:O:SCi6xL:0:1:2:3:Fbqk"
 
 static void print_usage(char *prog)
 {
 	printf(
 	"usage: %s OPTS\n"
@@ -1866,10 +1888,11 @@ static void print_usage(char *prog)
 	"    -2 dev        Expected device name (or index) to receive packet\n"
 	"    -3 dev        Expected device name (or index) to receive packets - server mode\n"
 	"\n"
 	"    -b            Bind test only.\n"
 	"    -q            Be quiet. Run test without printing anything.\n"
+	"    -k            Fork server in background after bind or listen.\n"
 	, prog, DEFAULT_PORT);
 }
 
 int main(int argc, char *argv[])
 {
@@ -2017,10 +2040,13 @@ int main(int argc, char *argv[])
 			quiet = 1;
 			break;
 		case 'x':
 			args.use_xfrm = 1;
 			break;
+		case 'k':
+			args.fork_background = 1;
+			break;
 		default:
 			print_usage(argv[0]);
 			return 1;
 		}
 	}
@@ -2058,10 +2084,16 @@ int main(int argc, char *argv[])
 		fprintf(stderr,
 			"Local (server mode) or remote IP (client IP) required\n");
 		return 1;
 	}
 
+	if (args.fork_background && (both_mode || !server_mode)) {
+		fprintf(stderr,
+			"Fork after listen only supported for server mode\n");
+		return 1;
+	}
+
 	if (interactive) {
 		prog_timeout = 0;
 		msg = NULL;
 	}
 
-- 
2.25.1

