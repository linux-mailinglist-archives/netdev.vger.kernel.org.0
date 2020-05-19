Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781CB1D97F6
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgESNjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:39:52 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39050 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728775AbgESNjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:39:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589895588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y9O0BWHPWfHZYA7BukFxm8M0FUyXrmOSFB61N9iTT3E=;
        b=gZayeAc1ELmIJC9E711C2KK1kpoPRXnyy8WD1zsQDAWYLly/DwQG6lDbhg9TQWRj7hLRAk
        njzUzmmttdWe+3EkD1WiVXwYG/Wn+DlCT5NpCYWPHoX2W33PMwDcD2gQUq268bMR47F8H5
        s5Wg3etJIo4hMBRT/KE4hnQQeecTJDw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-u9rIiZFCMM6x99axOIhoWw-1; Tue, 19 May 2020 09:39:45 -0400
X-MC-Unique: u9rIiZFCMM6x99axOIhoWw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69D0D1005510;
        Tue, 19 May 2020 13:39:43 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-95.rdu2.redhat.com [10.10.112.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 593EC649B5;
        Tue, 19 May 2020 13:39:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20200518155148.GA2595638@erythro.dev.benboeckel.internal>
References: <20200518155148.GA2595638@erythro.dev.benboeckel.internal> <158981176590.872823.11683683537698750702.stgit@warthog.procyon.org.uk>
To:     me@benboeckel.net
Cc:     dhowells@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, keyrings@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweimer@redhat.com
Subject: Re: [PATCH] dns: Apply a default TTL to records obtained from getaddrinfo()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1080377.1589895580.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 19 May 2020 14:39:40 +0100
Message-ID: <1080378.1589895580@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ben Boeckel <me@benboeckel.net> wrote:

> Is there precedent for this config file format?

Okay, I can change it to:

	default_ttl =3D <number-of-seconds>

and strip spaces all over the place.

> But no trailing whitespace is allowed?

Yes...  See a few lines above:

		while (p > buf && isspace(p[-1]))
			p--;
		*p =3D 0;

> The valid range should be mentioned in the docs (basically that 0 is not
> allowed and has no special meaning (it could mean leaving off the TTL as
> previously done)).

I suppose - that's mainly to make sure I'm not passing an invalid value to=
 the
syscall.

> Forwards compatibility is hard with such behavior. Is there any reason
> this can't be a warning?

I can downgrade it to a warning.  I'm not sure that there's any problem he=
re,
but I have met circumstances before where it is the wrong thing to ignore =
an
explicit option that you don't support rather than giving an error.

> There's no mention of the leading whitespace support or comments here.
> Does the file deserve its own manpage?

Um.  I'm not sure.  Quite possibly there should at least be a stub file wi=
th a
.so directive in it.

Anyway, how about the attached?

David
---
commit cbf0457e0fc99aa5beabe54daeda57be70dfdfce
Author: David Howells <dhowells@redhat.com>
Date:   Tue Apr 14 16:07:26 2020 +0100

    dns: Apply a default TTL to records obtained from getaddrinfo()
    =

    Address records obtained from getaddrinfo() don't come with any TTL
    information, even if they're obtained from the DNS, with the result th=
at
    key.dns_resolver upcall program doesn't set an expiry time on dns_reso=
lver
    records unless they include a component obtained directly from the DNS=
,
    such as an SRV or AFSDB record.
    =

    Fix this to apply a default TTL of 10mins in the event that we haven't=
 got
    one.  This can be configured in /etc/keyutils/key.dns_resolver.conf by
    adding the line:
    =

            default_ttl =3D <number-of-seconds>
    =

    to the file.
    =

    Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/Makefile b/Makefile
index 6f79446b..4d055701 100644
--- a/Makefile
+++ b/Makefile
@@ -202,6 +202,7 @@ endif
 	$(INSTALL) -D key.dns_resolver $(DESTDIR)$(SBINDIR)/key.dns_resolver
 	$(INSTALL) -D -m 0644 request-key.conf $(DESTDIR)$(ETCDIR)/request-key.c=
onf
 	mkdir -p $(DESTDIR)$(ETCDIR)/request-key.d
+	mkdir -p $(DESTDIR)$(ETCDIR)/keyutils
 	mkdir -p $(DESTDIR)$(MAN1)
 	$(INSTALL) -m 0644 $(wildcard man/*.1) $(DESTDIR)$(MAN1)
 	mkdir -p $(DESTDIR)$(MAN3)
diff --git a/dns.afsdb.c b/dns.afsdb.c
index fa60e04f..986c0f38 100644
--- a/dns.afsdb.c
+++ b/dns.afsdb.c
@@ -37,8 +37,6 @@
  */
 #include "key.dns.h"
 =

-static unsigned long afs_ttl =3D ULONG_MAX;
-
 /*
  *
  */
@@ -114,8 +112,8 @@ static void afsdb_hosts_to_addrs(ns_msg handle, ns_sec=
t section)
 		}
 	}
 =

-	afs_ttl =3D ttl;
-	info("ttl: %u", ttl);
+	key_expiry =3D ttl;
+	info("ttl: %u", key_expiry);
 }
 =

 /*
@@ -203,8 +201,8 @@ static void srv_hosts_to_addrs(ns_msg handle, ns_sect =
section)
 		}
 	}
 =

-	afs_ttl =3D ttl;
-	info("ttl: %u", ttl);
+	key_expiry =3D ttl;
+	info("ttl: %u", key_expiry);
 }
 =

 /*
@@ -240,7 +238,7 @@ static int dns_query_AFSDB(const char *cell)
 	/* look up the hostnames we've obtained to get the actual addresses */
 	afsdb_hosts_to_addrs(handle, ns_s_an);
 =

-	info("DNS query AFSDB RR results:%u ttl:%lu", payload_index, afs_ttl);
+	info("DNS query AFSDB RR results:%u ttl:%u", payload_index, key_expiry);
 	return 0;
 }
 =

@@ -279,7 +277,7 @@ static int dns_query_VL_SRV(const char *cell)
 	/* look up the hostnames we've obtained to get the actual addresses */
 	srv_hosts_to_addrs(handle, ns_s_an);
 =

-	info("DNS query VL SRV RR results:%u ttl:%lu", payload_index, afs_ttl);
+	info("DNS query VL SRV RR results:%u ttl:%u", payload_index, key_expiry)=
;
 	return 0;
 }
 =

@@ -293,7 +291,7 @@ void afs_instantiate(const char *cell)
 =

 	/* set the key's expiry time from the minimum TTL encountered */
 	if (!debug_mode) {
-		ret =3D keyctl_set_timeout(key, afs_ttl);
+		ret =3D keyctl_set_timeout(key, key_expiry);
 		if (ret =3D=3D -1)
 			error("%s: keyctl_set_timeout: %m", __func__);
 	}
diff --git a/key.dns.h b/key.dns.h
index b143f4a4..33d0ab3b 100644
--- a/key.dns.h
+++ b/key.dns.h
@@ -29,6 +29,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <time.h>
+#include <ctype.h>
 =

 #define	MAX_VLS			15	/* Max Volume Location Servers Per-Cell */
 #define	INET_IP4_ONLY		0x1
@@ -42,6 +43,7 @@
 extern key_serial_t key;
 extern int debug_mode;
 extern unsigned mask;
+extern unsigned int key_expiry;
 =

 #define N_PAYLOAD 256
 extern struct iovec payload[N_PAYLOAD];
@@ -52,6 +54,8 @@ void error(const char *fmt, ...);
 extern __attribute__((format(printf, 1, 2)))
 void _error(const char *fmt, ...);
 extern __attribute__((format(printf, 1, 2)))
+void warning(const char *fmt, ...);
+extern __attribute__((format(printf, 1, 2)))
 void info(const char *fmt, ...);
 extern __attribute__((noreturn))
 void nsError(int err, const char *domain);
diff --git a/key.dns_resolver.c b/key.dns_resolver.c
index 4ac27d30..c241eda3 100644
--- a/key.dns_resolver.c
+++ b/key.dns_resolver.c
@@ -46,10 +46,13 @@ static const char key_type[] =3D "dns_resolver";
 static const char a_query_type[] =3D "a";
 static const char aaaa_query_type[] =3D "aaaa";
 static const char afsdb_query_type[] =3D "afsdb";
+static const char *config_file =3D "/etc/keyutils/key.dns_resolver.conf";
+static bool config_specified =3D false;
 key_serial_t key;
 static int verbose;
 int debug_mode;
 unsigned mask =3D INET_ALL;
+unsigned int key_expiry =3D 10 * 60;
 =

 =

 /*
@@ -105,6 +108,23 @@ void _error(const char *fmt, ...)
 	va_end(va);
 }
 =

+/*
+ * Pring a warning to stderr or the syslog
+ */
+void warning(const char *fmt, ...)
+{
+	va_list va;
+
+	va_start(va, fmt);
+	if (isatty(2)) {
+		vfprintf(stderr, fmt, va);
+		fputc('\n', stderr);
+	} else {
+		vsyslog(LOG_WARNING, fmt, va);
+	}
+	va_end(va);
+}
+
 /*
  * Print status information
  */
@@ -272,6 +292,7 @@ void dump_payload(void)
 	}
 =

 	info("The key instantiation data is '%s'", buf);
+	info("The expiry time is %us", key_expiry);
 	free(buf);
 }
 =

@@ -412,6 +433,9 @@ int dns_query_a_or_aaaa(const char *hostname, char *op=
tions)
 =

 	/* load the key with data key */
 	if (!debug_mode) {
+		ret =3D keyctl_set_timeout(key, key_expiry);
+		if (ret =3D=3D -1)
+			error("%s: keyctl_set_timeout: %m", __func__);
 		ret =3D keyctl_instantiate_iov(key, payload, payload_index, 0);
 		if (ret =3D=3D -1)
 			error("%s: keyctl_instantiate: %m", __func__);
@@ -420,6 +444,145 @@ int dns_query_a_or_aaaa(const char *hostname, char *=
options)
 	exit(0);
 }
 =

+/*
+ * Read the config file.
+ */
+static void read_config(void)
+{
+	FILE *f;
+	char buf[4096], *b, *p, *k, *v;
+	unsigned int line =3D 0, u;
+	int n;
+
+	printf("READ CONFIG %s\n", config_file);
+
+	f =3D fopen(config_file, "r");
+	if (!f) {
+		if (errno =3D=3D ENOENT && !config_specified) {
+			debug("%s: %m", config_file);
+			return;
+		}
+		error("%s: %m", config_file);
+	}
+
+	while (fgets(buf, sizeof(buf) - 1, f)) {
+		line++;
+
+		/* Trim off leading and trailing spaces and discard whole-line
+		 * comments.
+		 */
+		b =3D buf;
+		while (isspace(*b))
+			b++;
+		if (!*b || *b =3D=3D '#')
+			continue;
+		p =3D strchr(b, '\n');
+		if (!p)
+			error("%s:%u: line missing newline or too long", config_file, line);
+		while (p > buf && isspace(p[-1]))
+			p--;
+		*p =3D 0;
+
+		/* Split into key[=3Dvalue] pairs and trim spaces. */
+		k =3D b;
+		v =3D NULL;
+		b =3D strchr(b, '=3D');
+		if (b) {
+			char quote =3D 0;
+			bool esc =3D false;
+
+			if (b =3D=3D k)
+				error("%s:%u: Unspecified key",
+				      config_file, line);
+
+			/* NUL-terminate the key. */
+			for (p =3D b - 1; isspace(*p); p--)
+				;
+			p[1] =3D 0;
+
+			/* Strip leading spaces */
+			b++;
+			while (isspace(*b))
+				b++;
+			if (!*b)
+				goto missing_value;
+
+			if (*b =3D=3D '"' || *b =3D=3D '\'') {
+				quote =3D *b;
+				b++;
+			}
+			v =3D p =3D b;
+			while (*b) {
+				if (esc) {
+					esc =3D false;
+					*p++ =3D *b++;
+					continue;
+				}
+				if (*b =3D=3D '\\') {
+					esc =3D true;
+					b++;
+					continue;
+				}
+				if (*b =3D=3D quote) {
+					b++;
+					if (*b)
+						goto post_quote_data;
+					quote =3D 0;
+					break;
+				}
+				if (!quote && *b =3D=3D '#')
+					break; /* Terminal comment */
+				*p++ =3D *b++;
+			}
+
+			if (esc)
+				error("%s:%u: Incomplete escape", config_file, line);
+			if (quote)
+				error("%s:%u: Unclosed quotes", config_file, line);
+			*p =3D 0;
+		}
+
+		if (strcmp(k, "default_ttl") =3D=3D 0) {
+			if (!v)
+				goto missing_value;
+			if (sscanf(v, "%u%n", &u, &n) !=3D 1)
+				goto bad_value;
+			if (v[n])
+				goto extra_data;
+			if (u < 1 || u > INT_MAX)
+				goto out_of_range;
+			key_expiry =3D u;
+		} else {
+			warning("%s:%u: Unknown option '%s'", config_file, line, k);
+		}
+	}
+
+	if (ferror(f) || fclose(f) =3D=3D EOF)
+		error("%s: %m", config_file);
+	return;
+
+missing_value:
+	error("%s:%u: %s: Missing value", config_file, line, k);
+post_quote_data:
+	error("%s:%u: %s: Data after closing quote", config_file, line, k);
+bad_value:
+	error("%s:%u: %s: Bad value", config_file, line, k);
+extra_data:
+	error("%s:%u: %s: Extra data supplied", config_file, line, k);
+out_of_range:
+	error("%s:%u: %s: Value out of range", config_file, line, k);
+}
+
+/*
+ * Dump the configuration after parsing the config file.
+ */
+static __attribute__((noreturn))
+void config_dumper(void)
+{
+	printf("default_ttl =3D %u\n", key_expiry);
+	exit(0);
+}
+
 /*
  * Print usage details,
  */
@@ -428,22 +591,24 @@ void usage(void)
 {
 	if (isatty(2)) {
 		fprintf(stderr,
-			"Usage: %s [-vv] key_serial\n",
+			"Usage: %s [-vv] [-c config] key_serial\n",
 			prog);
 		fprintf(stderr,
-			"Usage: %s -D [-vv] <desc> <calloutinfo>\n",
+			"Usage: %s -D [-vv] [-c config] <desc> <calloutinfo>\n",
 			prog);
 	} else {
-		info("Usage: %s [-vv] key_serial", prog);
+		info("Usage: %s [-vv] [-c config] key_serial", prog);
 	}
 	exit(2);
 }
 =

-const struct option long_options[] =3D {
-	{ "debug",	0, NULL, 'D' },
-	{ "verbose",	0, NULL, 'v' },
-	{ "version",	0, NULL, 'V' },
-	{ NULL,		0, NULL, 0 }
+static const struct option long_options[] =3D {
+	{ "config",		0, NULL, 'c' },
+	{ "debug",		0, NULL, 'D' },
+	{ "dump-config",	0, NULL, 2   },
+	{ "verbose",		0, NULL, 'v' },
+	{ "version",		0, NULL, 'V' },
+	{ NULL,			0, NULL, 0 }
 };
 =

 /*
@@ -455,11 +620,19 @@ int main(int argc, char *argv[])
 	char *keyend, *p;
 	char *callout_info =3D NULL;
 	char *buf =3D NULL, *name;
+	bool dump_config =3D false;
 =

 	openlog(prog, 0, LOG_DAEMON);
 =

-	while ((ret =3D getopt_long(argc, argv, "vDV", long_options, NULL)) !=3D=
 -1) {
+	while ((ret =3D getopt_long(argc, argv, "c:vDV", long_options, NULL)) !=3D=
 -1) {
 		switch (ret) {
+		case 'c':
+			config_file =3D optarg;
+			config_specified =3D true;
+			continue;
+		case 2:
+			dump_config =3D true;
+			continue;
 		case 'D':
 			debug_mode =3D 1;
 			continue;
@@ -481,6 +654,9 @@ int main(int argc, char *argv[])
 =

 	argc -=3D optind;
 	argv +=3D optind;
+	read_config();
+	if (dump_config)
+		config_dumper();
 =

 	if (!debug_mode) {
 		if (argc !=3D 1)
@@ -542,7 +718,7 @@ int main(int argc, char *argv[])
 	name++;
 =

 	info("Query type: '%*.*s'", qtlen, qtlen, keyend);
-	=

+
 	if ((qtlen =3D=3D sizeof(a_query_type) - 1 &&
 	     memcmp(keyend, a_query_type, sizeof(a_query_type) - 1) =3D=3D 0) ||
 	    (qtlen =3D=3D sizeof(aaaa_query_type) - 1 &&
diff --git a/man/key.dns_resolver.8 b/man/key.dns_resolver.8
index e1882e06..0b17edd6 100644
--- a/man/key.dns_resolver.8
+++ b/man/key.dns_resolver.8
@@ -7,28 +7,41 @@
 .\" as published by the Free Software Foundation; either version
 .\" 2 of the License, or (at your option) any later version.
 .\"
-.TH KEY.DNS_RESOLVER 8 "04 Mar 2011" Linux "Linux Key Management Utilitie=
s"
+.TH KEY.DNS_RESOLVER 8 "18 May 2020" Linux "Linux Key Management Utilitie=
s"
 .SH NAME
 key.dns_resolver \- upcall for request\-key to handle dns_resolver keys
 .SH SYNOPSIS
 \fB/sbin/key.dns_resolver \fR<key>
 .br
-\fB/sbin/key.dns_resolver \fR\-D [\-v] [\-v] <keydesc> <calloutinfo>
+\fB/sbin/key.dns_resolver \fR--dump-config [\-c <configfile>]
+.br
+\fB/sbin/key.dns_resolver \fR\-D [\-v] [\-v] [\-c <configfile>] <desc>
+.br
+<calloutinfo>
 .SH DESCRIPTION
 This program is invoked by request\-key on behalf of the kernel when kern=
el
 services (such as NFS, CIFS and AFS) want to perform a hostname lookup an=
d the
 kernel does not have the key cached.  It is not ordinarily intended to be
 called directly.
 .P
-It can be called in debugging mode to test its functionality by passing a
-\fB\-D\fR flag on the command line.  For this to work, the key descriptio=
n and
-the callout information must be supplied.  Verbosity can be increased by
-supplying one or more \fB\-v\fR flags.
+There program has internal parameters that can be changed with a configur=
ation
+file (see key.dns_resolver.conf(5) for more information).  The default
+configuration file is in /etc, but this can be overridden with the \fB-c\=
fR
+flag.
+.P
+The program can be called in debugging mode to test its functionality by
+passing a \fB\-D\fR or \fB\--debug\fR flag on the command line.  For this=
 to
+work, the key description and the callout information must be supplied.
+Verbosity can be increased by supplying one or more \fB\-v\fR flags.
+.P
+The program may also be called with \fB--dump-config\fR to show the value=
s that
+configurable parameters will have after parsing the config file.
 .SH ERRORS
 All errors will be logged to the syslog.
 .SH SEE ALSO
 .ad l
 .nh
+.BR key.dns_resolver.conf (5),
 .BR request\-key.conf (5),
 .BR keyrings (7),
 .BR request\-key (8)
diff --git a/man/key.dns_resolver.conf.5 b/man/key.dns_resolver.conf.5
new file mode 100644
index 00000000..03d04049
--- /dev/null
+++ b/man/key.dns_resolver.conf.5
@@ -0,0 +1,48 @@
+.\" -*- nroff -*-
+.\" Copyright (C) 2020 Red Hat, Inc. All Rights Reserved.
+.\" Written by David Howells (dhowells@redhat.com)
+.\"
+.\" This program is free software; you can redistribute it and/or
+.\" modify it under the terms of the GNU General Public License
+.\" as published by the Free Software Foundation; either version
+.\" 2 of the License, or (at your option) any later version.
+.\"
+.TH KEY.DNS_RESOLVER.CONF 5 "18 May 2020" Linux "Linux Key Management Uti=
lities"
+.SH NAME
+key.dns_resolver.conf \- Kernel DNS resolver config
+.SH DESCRIPTION
+This file is used by the key.dns_resolver(5) program to set parameters.
+Unless otherwise overridden with the \fB\-c\fR flag, the program reads:
+.IP
+/etc/key.dns_resolver.conf
+.P
+Configuration options are given in \fBkey[=3Dvalue]\fR form, where \fBval=
ue\fR is
+optional.  If present, the value may be surrounded by a pair of single ('=
') or
+double quotes ("") which will be stripped off.  The special characters in=
 the
+value may be escaped with a backslash to turn them into ordinary characte=
rs.
+.P
+Lines beginning with a '#' are considered comments and ignored.  A '#' sy=
mbol
+anywhere after the '=3D' makes the rest of the line into a comment unless=
 the '#'
+is inside a quoted section or is escaped.
+.P
+Leading and trailing spaces and spaces around the '=3D' symbol will be st=
ripped
+off.
+.P
+Available options include:
+.TP
+.B default_ttl=3D<number>
+The number of seconds to set as the expiration on a cached record.  This =
will
+be overridden if the program manages to retrieve TTL information along wi=
th
+the addresses (if, for example, it accesses the DNS directly).  The defau=
lt is
+600 seconds.  The value must be in the range 1 to INT_MAX.
+.P
+The file can also include comments beginning with a '#' character unless
+otherwise suppressed by being inside a quoted value or being escaped with=
 a
+backslash.
+
+.SH FILES
+.ul
+/etc/key.dns_resolver.conf
+.ul 0
+.SH SEE ALSO
+\fBkey.dns_resolver\fR(8)

