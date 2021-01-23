Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5D830131D
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 05:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbhAWEzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 23:55:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbhAWEyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 23:54:52 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7101C061794
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 20:53:59 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 11so5180263pfu.4
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 20:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=LI6HKM/0jE7QF0K+h0o5q3QojmaF5bUVzmQHTFlOYdk=;
        b=GkL0M0V/Jfs/BUU9I9u7abs/+DHik3sM/GkLr+7gxHX38Nrr9OgL6Oij/m9UZlAdFM
         CmUeqRWO/U7KkEOJQ9fs7NA1Ly91/RO4IYMUQlGK4sR4Z5Xk2jyF33+DDh4F5as27Zyx
         cLA7UiezGIKCvIRPszJsH9cLMS93wUk+uf9/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=LI6HKM/0jE7QF0K+h0o5q3QojmaF5bUVzmQHTFlOYdk=;
        b=jqIiPHfX0bPdcQO1UuNwtNzhdBoYoRKfbEf778eoqJQoF4r1i+SHiPOK5Eev1uMmxd
         9PKVqG0QEcRhQU4EXfm+bLiJMThHVwTCXmXNVv1wSOu5oAzonNUBlpY4/etrOwmmxJA2
         GviIzFOPYicZIbZxcWtJAuRHe1UfRaVADBmoFp0IskCpVbw7TJ1teMgYq5Exz5/89dcU
         0k+D//PiyTzTrUL5r+7SYnBSvvVja9gI7YDexsgCGE4/gnc/XEDVihVavD4XYj2NvqGW
         UfvVaeo1lAkg4eaczscrg9fv1rlGcj2OPEPsW6fXJUguWdOQxx29CAJ+i4YlTksE5dnw
         UVWg==
X-Gm-Message-State: AOAM53266wvQclhNiPI/1SUgOH/y31EyQ7RkoiF3vwrHxOBNcmotGDZf
        aZ7JilUVF243KSwYstwGbEg2k0gyh31tBszaUgBu2M3uoxvLW1bbIQSSJsO9U2O0MvVZQX/VkAm
        UpivoawFWf+h5zArxpw6Hm4ne75nRKgVpHSlaefHOtgZqGglEqodsn1+uwZC7N2U9NZr97PiI
X-Google-Smtp-Source: ABdhPJxpZWybz67XNnA04/l/wnN39xhCGxsaecNgaEx4vqTN1ucp4QMmlEdlh2u7wGs8DGlPcxeFRw==
X-Received: by 2002:a62:31c7:0:b029:1b8:4194:8982 with SMTP id x190-20020a6231c70000b02901b841948982mr8354488pfx.33.1611377638639;
        Fri, 22 Jan 2021 20:53:58 -0800 (PST)
Received: from hex.swdvt.lab.broadcom.net ([2600:8802:d04:de02::77c])
        by smtp.gmail.com with ESMTPSA id k3sm9675743pgm.94.2021.01.22.20.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 20:53:57 -0800 (PST)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 2/4] lib: iplink: print warnings for missing data
Date:   Fri, 22 Jan 2021 20:53:49 -0800
Message-Id: <20210123045351.2797433-2-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210123045351.2797433-1-edwin.peer@broadcom.com>
References: <20210123045351.2797433-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c87f0605b98a17a8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000c87f0605b98a17a8
Content-Transfer-Encoding: 8bit

The kernel might truncate VF info in IFLA_VFINFO_LIST. Sufficiently new
kernels will provide NLM_F_NEST_TRUNCATED in these cases, but this flag
has limited resolution, as it pertains to the entire netlink message. A
better approach is to compare the expected number of VFs in IFLA_NUM_VF
to how many were found in the list and warn accordingly.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 ip/ipaddress.c   |  9 ++++++++-
 lib/libnetlink.c | 12 ++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 571346b15cc3..0bbcee2b3bb2 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -922,6 +922,7 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 	const char *name;
 	unsigned int m_flag = 0;
 	SPRINT_BUF(b1);
+	bool truncated_vfs = false;
 
 	if (n->nlmsg_type != RTM_NEWLINK && n->nlmsg_type != RTM_DELLINK)
 		return 0;
@@ -1199,15 +1200,18 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 
 	if ((do_link || show_details) && tb[IFLA_VFINFO_LIST] && tb[IFLA_NUM_VF]) {
 		struct rtattr *i, *vflist = tb[IFLA_VFINFO_LIST];
-		int rem = RTA_PAYLOAD(vflist);
+		int rem = RTA_PAYLOAD(vflist), count = 0;
 
 		open_json_array(PRINT_JSON, "vfinfo_list");
 		for (i = RTA_DATA(vflist); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
 			open_json_object(NULL);
 			print_vfinfo(fp, ifi, i);
 			close_json_object();
+			count++;
 		}
 		close_json_array(PRINT_JSON, NULL);
+		if (count != rta_getattr_u32(tb[IFLA_NUM_VF]))
+			truncated_vfs = true;
 	}
 
 	if (tb[IFLA_PROP_LIST]) {
@@ -1228,6 +1232,9 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 
 	print_string(PRINT_FP, NULL, "%s", "\n");
 	fflush(fp);
+	/* prettier here if stderr and stdout go to the same place */
+	if (truncated_vfs)
+		fprintf(stderr, "Truncated VF list: %s\n", name);
 	return 1;
 }
 
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index c958aa57d0cd..b1f07d4570cf 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -833,6 +833,9 @@ static int rtnl_dump_filter_l(struct rtnl_handle *rth,
 				if (h->nlmsg_flags & NLM_F_DUMP_INTR)
 					dump_intr = 1;
 
+				if (h->nlmsg_flags & NLM_F_NEST_TRUNCATED)
+					fprintf(stderr, "Incomplete data: truncated attribute list\n");
+
 				if (h->nlmsg_type == NLMSG_DONE) {
 					err = rtnl_dump_done(h);
 					if (err < 0) {
@@ -978,6 +981,9 @@ next:
 				continue;
 			}
 
+			if (h->nlmsg_flags & NLM_F_NEST_TRUNCATED)
+				fprintf(stderr, "Incomplete data: truncated attribute list\n");
+
 			if (h->nlmsg_type == NLMSG_ERROR) {
 				struct nlmsgerr *err = (struct nlmsgerr *)NLMSG_DATA(h);
 				int error = err->error;
@@ -1156,6 +1162,9 @@ int rtnl_listen(struct rtnl_handle *rtnl,
 				exit(1);
 			}
 
+			if (h->nlmsg_flags & NLM_F_NEST_TRUNCATED)
+				fprintf(stderr, "Incomplete data: truncated attribute list\n");
+
 			err = handler(&ctrl, h, jarg);
 			if (err < 0)
 				return err;
@@ -1206,6 +1215,9 @@ int rtnl_from_file(FILE *rtnl, rtnl_listen_filter_t handler,
 			return -1;
 		}
 
+		if (h->nlmsg_flags & NLM_F_NEST_TRUNCATED)
+			fprintf(stderr, "Incomplete data: truncated attribute list\n");
+
 		status = fread(NLMSG_DATA(h), 1, NLMSG_ALIGN(l), rtnl);
 
 		if (status != NLMSG_ALIGN(l)) {
-- 
2.30.0


--000000000000c87f0605b98a17a8
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
mbo++PCnVfHaIk6rK1M0CPodEV0uUttmi6Mp/Ha7XmNgWQeQE3qkFIwAlb/kPNmJAMECAwEAAaOC
Ac4wggHKMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUHMAKGQWh0
dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNoYTJnM29j
c3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25h
bHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRw
czovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1UdHwQ9MDsw
OaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hhMmczLmNy
bDAiBgNVHREEGzAZgRdlZHdpbi5wZWVyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcD
BDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU9IOrXBkaTFAmOmjl
0nu9X2Lzo+0wDQYJKoZIhvcNAQELBQADggEBADL+5FenxoguXoMm8ZG+bsMvN0LibFO75wee8cJI
3K8dcJ8y6rPc6yvMRqI7CNwjWV5kBT3aQPZCdqOlNLl/HnKJxBt3WJRWGePcE1s/ljK4Kg1rUQAo
e3Fx6cKh9/q3gqElSPU5pBOsCEy8cbi6UGA+IVifQ2Mrm5tsvYqWSaZ1mKTGz8/z8vxG2kGJZI6W
wL3owFiCmLmw5R8OH22wqf/7sQFMRpH5IQFLRYdU9uCUy5FlUAgiCEXegph8ytxvo8MgYyQcCOeg
BMfFgFEHuM2IgsDQyFC6XUViX6BQny67nlrO8pqwNRJ9Bdd7ykLCzCLOuR1znBAc2wAL9OKQe0cx
ggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMw
MQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDCXgDAeB
YW0HGKjSdzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgp5fsJ3VRx6gxqSweXHsF
SC7+IhTvMzuV3g6pnlvQ/1swGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjEwMTIzMDQ1MzU5WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQME
ARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAFYc3ClM3CeYlfF6/6eRgahwlgKVz1FpJabpKWEo
i5Ewhk7gmtspNZmvdKGCDMDELlfjHsCCq6UE4Z/Akpe5Sv8Zb6l3dVu//lYxeUAD0+sQWLX44h7U
DPemijCsyRkZuBKxWb9muiBLVALsi1suMKw3SlQEaQ+1YDkRy1ksAPTzVXw+XqQXPk789GqVbGCb
B1dmStOgi1hbjk0kbkFXdNdBczLN1ouZCx6DAWH3qiRO1dn2NqgwR+2FvaSpxKoL2kNX41STgXm2
sv/sF+hraC4VtiObtGyj7xwMM87YFfu9wAObbJMPdJNIVH/3bY5CyWDRAJo2YJgeOydVBMRz8qE=
--000000000000c87f0605b98a17a8--
