Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7726B30131E
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 05:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbhAWEzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 23:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbhAWEyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 23:54:54 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E3DC061797
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 20:54:01 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id m5so5141566pjv.5
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 20:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=ijQyXmtUqboHOtjn+T8pA+UT/7phNjo4BxqNiVOV+YU=;
        b=MTIurxjAMBXk+CtNRSuOUou/Ws70uqIAHtx09VbjjCOXsVga3AkRGCSWQYhF5A1vMk
         aTPfJJVT8lw7xSLtMPAgaAenDsgOCl4sdxovb8svOLFJb4f5/REgPT76AUTFeuCk5ieM
         8pZrENca21NxPF8SarKi13ckMDHteRVcbXtLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=ijQyXmtUqboHOtjn+T8pA+UT/7phNjo4BxqNiVOV+YU=;
        b=Mhe4Av292mc9fQXpk96SPA8Xj7OYpmivygIg4PzJ+w66ezvr7sh6MD3WoZpfTBo2/5
         1a6e3nLiXwC5qZtI9ChiROKbprHNNCf3pUoo7T/qMdPFOQwpRZfMgOFrYVuBD3ZQoPib
         MlXRSS5cH1CS6YdztyQn4V/+1UvCKpExLFB3kMxk9RoKHC1XxU9Q/5OuJGpnCm3n0fDX
         x5lVSO5/PonT6JTl4y4RoqSIZEMapKvDp1T59/+xIbWfGxxJ8QoAdqAKt6+USheQfEAv
         /KjQl/UfqmUeQzZrXUQF3wIc78akK1aMr9jluYNb2ocHdfoix+cAtdX0b2SRDeMxWT7C
         uNTw==
X-Gm-Message-State: AOAM5339GPObh4AG6FCv+1QvbB13E241qaln0O4pH7A+cAgdt+WSdLnh
        AEY8Wzry53D5qVdyIBBF7QbDaMZ4DwyHSFf9KnTed9JLHdVpOfTKBc7R4UiCmOpxgdeA2dl39Au
        RB4VRwUog5xN1rsA4AnCgS0Fhe7IbPeE0RlNUPgQdT5ALdUi2w2wWx5krS1saOZMp45K4HbnI
X-Google-Smtp-Source: ABdhPJybMlpHFpPi1L9MwKWnN6qPTXFy2ENv0fDe25zFoj8PhVksnpx0CzMbh2VO6Ssjp7pmGELa3w==
X-Received: by 2002:a17:90a:eacf:: with SMTP id ev15mr9400480pjb.209.1611377640598;
        Fri, 22 Jan 2021 20:54:00 -0800 (PST)
Received: from hex.swdvt.lab.broadcom.net ([2600:8802:d04:de02::77c])
        by smtp.gmail.com with ESMTPSA id k3sm9675743pgm.94.2021.01.22.20.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 20:53:59 -0800 (PST)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 3/4] iplink: filter stats using RTEXT_FILTER_SKIP_STATS
Date:   Fri, 22 Jan 2021 20:53:50 -0800
Message-Id: <20210123045351.2797433-3-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210123045351.2797433-1-edwin.peer@broadcom.com>
References: <20210123045351.2797433-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e3f49405b98a1757"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e3f49405b98a1757
Content-Transfer-Encoding: 8bit

Don't request statistics we do not intend to render. This is a step
towards avoiding a truncated IFLA_VFINFO_LIST. It also avoids fetching
unnecessary data, reducing netlink traffic.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 ip/ipaddress.c | 6 +++++-
 ip/iplink.c    | 3 +++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 0bbcee2b3bb2..75511881050d 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1882,9 +1882,13 @@ static int ipaddr_flush(void)
 
 static int iplink_filter_req(struct nlmsghdr *nlh, int reqlen)
 {
+	__u32 filt_mask;
 	int err;
 
-	err = addattr32(nlh, reqlen, IFLA_EXT_MASK, RTEXT_FILTER_VF);
+	filt_mask = RTEXT_FILTER_VF;
+	if (!show_stats)
+		filt_mask |= RTEXT_FILTER_SKIP_STATS;
+	err = addattr32(nlh, reqlen, IFLA_EXT_MASK, filt_mask);
 	if (err)
 		return err;
 
diff --git a/ip/iplink.c b/ip/iplink.c
index 27c9be442a7a..6a973213dc11 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -1116,6 +1116,9 @@ int iplink_get(char *name, __u32 filt_mask)
 			  !check_ifname(name) ? IFLA_IFNAME : IFLA_ALT_IFNAME,
 			  name, strlen(name) + 1);
 	}
+
+	if (!show_stats)
+		filt_mask |= RTEXT_FILTER_SKIP_STATS;
 	addattr32(&req.n, sizeof(req), IFLA_EXT_MASK, filt_mask);
 
 	if (rtnl_talk(&rth, &req.n, &answer) < 0)
-- 
2.30.0


--000000000000e3f49405b98a1757
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
YW0HGKjSdzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgI3fBq6z8edsAWDwVTa7Q
WmsDJxrrFceM3L1mzfrZJQcwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjEwMTIzMDQ1NDAwWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQME
ARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBADJG22msjhuUO26bGVDuy9aoi00jjlH8bwuNnpY4
aPpfcWJ+8+2BWvYM2Uunz9GjnP+xSM1fmTEPoMa7KhYLCmfFlRMpcsx1sH/LSsgopssLreX+74Vg
sPc+BVIz84zKYC4elKl9ZI3R0xDRY+pvaogSHchJPWZd3/dRHSjJez9fqlVqGrjkEI8KQamEFK8Q
CMZpq+8YxW83FxtjGbTZFEsLVmpvw0fbkFgGbOGmXgvFDl+CO8EYxo+aOsdGpilZyPoSxaCchoKF
aVjYZeMfNZjXDh1WdDPwt5danhtPBAUGkErL+WjDScd2c70q8NaCeWnxGmcj8GqMwzNq/0iy2yM=
--000000000000e3f49405b98a1757--
