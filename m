Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074F112504A
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbfLRSIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:08:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27531 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727650AbfLRSIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:08:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576692479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SLZdv4nILYavPlNd4vydpr9CWIiu4xi175TY2KQEKPY=;
        b=E9oTB5wKl/5Z1BZzGhIockuP9KyQ5L/Rbng23a/LlJszmVXF626Z3SweTm0d0OIQt7whCE
        A2OzkOVwTKJc8PDBFffAP0ADulcEdss2VqORyEf86JHkGLQ5fqWS3N+gQKyBOT0ulRR6mO
        Z5+6w2Ihojx+pt5lvuf3VOCTie4Tak8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-34aWA1McOgOly0raw9LTwA-1; Wed, 18 Dec 2019 13:07:55 -0500
X-MC-Unique: 34aWA1McOgOly0raw9LTwA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C0E28C3ECB;
        Wed, 18 Dec 2019 18:07:54 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-218.ams2.redhat.com [10.36.117.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 801B05D9E2;
        Wed, 18 Dec 2019 18:07:49 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH net-next v3 09/11] testing/vsock: add parameters to list and skip tests
Date:   Wed, 18 Dec 2019 19:07:06 +0100
Message-Id: <20191218180708.120337-10-sgarzare@redhat.com>
In-Reply-To: <20191218180708.120337-1-sgarzare@redhat.com>
References: <20191218180708.120337-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some tests can fail with transports that have a slightly
different behavior, so let's add the possibility to specify
which tests to skip.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 tools/testing/vsock/control.c         | 15 +++++-
 tools/testing/vsock/control.h         |  1 +
 tools/testing/vsock/util.c            | 76 +++++++++++++++++++++------
 tools/testing/vsock/util.h            |  6 ++-
 tools/testing/vsock/vsock_diag_test.c | 19 ++++++-
 tools/testing/vsock/vsock_test.c      | 20 ++++++-
 6 files changed, 117 insertions(+), 20 deletions(-)

diff --git a/tools/testing/vsock/control.c b/tools/testing/vsock/control.=
c
index 45f328c6ff23..4874872fc5a3 100644
--- a/tools/testing/vsock/control.c
+++ b/tools/testing/vsock/control.c
@@ -205,11 +205,22 @@ void control_expectln(const char *str)
 	char *line;
=20
 	line =3D control_readln();
-	if (strcmp(str, line) !=3D 0) {
+
+	control_cmpln(line, str, true);
+
+	free(line);
+}
+
+bool control_cmpln(char *line, const char *str, bool fail)
+{
+	if (strcmp(str, line) =3D=3D 0)
+		return true;
+
+	if (fail) {
 		fprintf(stderr, "expected \"%s\" on control socket, got \"%s\"\n",
 			str, line);
 		exit(EXIT_FAILURE);
 	}
=20
-	free(line);
+	return false;
 }
diff --git a/tools/testing/vsock/control.h b/tools/testing/vsock/control.=
h
index dac3964a891d..51814b4f9ac1 100644
--- a/tools/testing/vsock/control.h
+++ b/tools/testing/vsock/control.h
@@ -10,5 +10,6 @@ void control_cleanup(void);
 void control_writeln(const char *str);
 char *control_readln(void);
 void control_expectln(const char *str);
+bool control_cmpln(char *line, const char *str, bool fail);
=20
 #endif /* CONTROL_H */
diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index b132c96c87fc..b290fa78405f 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -299,32 +299,78 @@ void run_tests(const struct test_case *test_cases,
=20
 	for (i =3D 0; test_cases[i].name; i++) {
 		void (*run)(const struct test_opts *opts);
+		char *line;
=20
-		printf("%s...", test_cases[i].name);
+		printf("%d - %s...", i, test_cases[i].name);
 		fflush(stdout);
=20
-		if (opts->mode =3D=3D TEST_MODE_CLIENT) {
-			/* Full barrier before executing the next test.  This
-			 * ensures that client and server are executing the
-			 * same test case.  In particular, it means whoever is
-			 * faster will not see the peer still executing the
-			 * last test.  This is important because port numbers
-			 * can be used by multiple test cases.
-			 */
-			control_expectln("NEXT");
+		/* Full barrier before executing the next test.  This
+		 * ensures that client and server are executing the
+		 * same test case.  In particular, it means whoever is
+		 * faster will not see the peer still executing the
+		 * last test.  This is important because port numbers
+		 * can be used by multiple test cases.
+		 */
+		if (test_cases[i].skip)
+			control_writeln("SKIP");
+		else
 			control_writeln("NEXT");
=20
-			run =3D test_cases[i].run_client;
-		} else {
-			control_writeln("NEXT");
-			control_expectln("NEXT");
+		line =3D control_readln();
+		if (control_cmpln(line, "SKIP", false) || test_cases[i].skip) {
=20
-			run =3D test_cases[i].run_server;
+			printf("skipped\n");
+
+			free(line);
+			continue;
 		}
=20
+		control_cmpln(line, "NEXT", true);
+		free(line);
+
+		if (opts->mode =3D=3D TEST_MODE_CLIENT)
+			run =3D test_cases[i].run_client;
+		else
+			run =3D test_cases[i].run_server;
+
 		if (run)
 			run(opts);
=20
 		printf("ok\n");
 	}
 }
+
+void list_tests(const struct test_case *test_cases)
+{
+	int i;
+
+	printf("ID\tTest name\n");
+
+	for (i =3D 0; test_cases[i].name; i++)
+		printf("%d\t%s\n", i, test_cases[i].name);
+
+	exit(EXIT_FAILURE);
+}
+
+void skip_test(struct test_case *test_cases, size_t test_cases_len,
+	       const char *test_id_str)
+{
+	unsigned long test_id;
+	char *endptr =3D NULL;
+
+	errno =3D 0;
+	test_id =3D strtoul(test_id_str, &endptr, 10);
+	if (errno || *endptr !=3D '\0') {
+		fprintf(stderr, "malformed test ID \"%s\"\n", test_id_str);
+		exit(EXIT_FAILURE);
+	}
+
+	if (test_id >=3D test_cases_len) {
+		fprintf(stderr, "test ID (%lu) larger than the max allowed (%lu)\n",
+			test_id, test_cases_len - 1);
+		exit(EXIT_FAILURE);
+	}
+
+	test_cases[test_id].skip =3D true;
+}
+
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index 331e945f3ae6..e53dd09d26d9 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -29,6 +29,8 @@ struct test_case {
=20
 	/* Called when test mode is TEST_MODE_SERVER */
 	void (*run_server)(const struct test_opts *opts);
+
+	bool skip;
 };
=20
 void init_signals(void);
@@ -41,5 +43,7 @@ void send_byte(int fd, int expected_ret, int flags);
 void recv_byte(int fd, int expected_ret, int flags);
 void run_tests(const struct test_case *test_cases,
 	       const struct test_opts *opts);
-
+void list_tests(const struct test_case *test_cases);
+void skip_test(struct test_case *test_cases, size_t test_cases_len,
+	       const char *test_id_str);
 #endif /* UTIL_H */
diff --git a/tools/testing/vsock/vsock_diag_test.c b/tools/testing/vsock/=
vsock_diag_test.c
index abd7dc2a9631..b82483627259 100644
--- a/tools/testing/vsock/vsock_diag_test.c
+++ b/tools/testing/vsock/vsock_diag_test.c
@@ -463,6 +463,16 @@ static const struct option longopts[] =3D {
 		.has_arg =3D required_argument,
 		.val =3D 'p',
 	},
+	{
+		.name =3D "list",
+		.has_arg =3D no_argument,
+		.val =3D 'l',
+	},
+	{
+		.name =3D "skip",
+		.has_arg =3D required_argument,
+		.val =3D 's',
+	},
 	{
 		.name =3D "help",
 		.has_arg =3D no_argument,
@@ -473,7 +483,7 @@ static const struct option longopts[] =3D {
=20
 static void usage(void)
 {
-	fprintf(stderr, "Usage: vsock_diag_test [--help] [--control-host=3D<hos=
t>] --control-port=3D<port> --mode=3Dclient|server --peer-cid=3D<cid>\n"
+	fprintf(stderr, "Usage: vsock_diag_test [--help] [--control-host=3D<hos=
t>] --control-port=3D<port> --mode=3Dclient|server --peer-cid=3D<cid> [--=
list] [--skip=3D<test_id>]\n"
 		"\n"
 		"  Server: vsock_diag_test --control-port=3D1234 --mode=3Dserver --pee=
r-cid=3D3\n"
 		"  Client: vsock_diag_test --control-host=3D192.168.0.1 --control-port=
=3D1234 --mode=3Dclient --peer-cid=3D2\n"
@@ -528,6 +538,13 @@ int main(int argc, char **argv)
 		case 'P':
 			control_port =3D optarg;
 			break;
+		case 'l':
+			list_tests(test_cases);
+			break;
+		case 's':
+			skip_test(test_cases, ARRAY_SIZE(test_cases) - 1,
+				  optarg);
+			break;
 		case '?':
 		default:
 			usage();
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock=
_test.c
index 629d7ce58202..3ac56651f3f9 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -13,6 +13,7 @@
 #include <string.h>
 #include <errno.h>
 #include <unistd.h>
+#include <linux/kernel.h>
=20
 #include "timeout.h"
 #include "control.h"
@@ -222,6 +223,16 @@ static const struct option longopts[] =3D {
 		.has_arg =3D required_argument,
 		.val =3D 'p',
 	},
+	{
+		.name =3D "list",
+		.has_arg =3D no_argument,
+		.val =3D 'l',
+	},
+	{
+		.name =3D "skip",
+		.has_arg =3D required_argument,
+		.val =3D 's',
+	},
 	{
 		.name =3D "help",
 		.has_arg =3D no_argument,
@@ -232,7 +243,7 @@ static const struct option longopts[] =3D {
=20
 static void usage(void)
 {
-	fprintf(stderr, "Usage: vsock_test [--help] [--control-host=3D<host>] -=
-control-port=3D<port> --mode=3Dclient|server --peer-cid=3D<cid>\n"
+	fprintf(stderr, "Usage: vsock_test [--help] [--control-host=3D<host>] -=
-control-port=3D<port> --mode=3Dclient|server --peer-cid=3D<cid> [--list]=
 [--skip=3D<test_id>]\n"
 		"\n"
 		"  Server: vsock_test --control-port=3D1234 --mode=3Dserver --peer-cid=
=3D3\n"
 		"  Client: vsock_test --control-host=3D192.168.0.1 --control-port=3D12=
34 --mode=3Dclient --peer-cid=3D2\n"
@@ -287,6 +298,13 @@ int main(int argc, char **argv)
 		case 'P':
 			control_port =3D optarg;
 			break;
+		case 'l':
+			list_tests(test_cases);
+			break;
+		case 's':
+			skip_test(test_cases, ARRAY_SIZE(test_cases) - 1,
+				  optarg);
+			break;
 		case '?':
 		default:
 			usage();
--=20
2.24.1

