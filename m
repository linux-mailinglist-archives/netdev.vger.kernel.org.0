Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E59609035
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 00:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJVWCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 18:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiJVWC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 18:02:29 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8810D80F79
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 15:02:28 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id u7so4225345qvn.13
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 15:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2nyTtb16GO7O1EXRrlxGdLq/LW/yRO//Vbu/6WFaHRA=;
        b=MzLIU8UQAGJDuOgmw5YOkEuREtpYis5sqihw8Pw0jDsOOm3m+80fW29JMMrkMeqe9i
         jF7A4fBXNBnlQ57bP0mxzXDbt1HMml7FAsgHWi+Sv/yIN7MrKwEQFB/pFxZbDvVSj9ZZ
         U4QTT+ap7mY8ME1fboyvG6Kv8eE62WXJefoQQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2nyTtb16GO7O1EXRrlxGdLq/LW/yRO//Vbu/6WFaHRA=;
        b=q+BGAqeVLkjXCRvQRqVUNWRxlq4b9IpiMClJC7VUEB4Ms/WHWSaMPbMSx1LU+vl+ma
         K+9ndem3Zg8LvOhufwrU3CF+SANm5dUyVd7TOGEuDOwA7v82/QLpWHvLWKOHmoe85/iX
         g8Iqg4mkgbvknRM3GxqYShNfIX0V0MjRXyk4oK0nyUpqYYr0EAlbOsnofYLd2EDpedkD
         R1SWKw7O/lqjsKuUl19ClZLHSnbHPCUuAQZzKxijex/wPLcUe0YIaslxksw7c0pRQzhI
         0qtVtTUM592bT1f5Cih1HuJsFDvnYDbRVU3ElnDI7em7428Y/9eAkDAXLJu6JMFvygTo
         xuqQ==
X-Gm-Message-State: ACrzQf0yZLv5EDrlK+dwdMruXuyDr5+41g1H1YUFBgt9r+1ikvy5Eo2y
        yl0wg7akgsV8YLpjYbwHVNmYmIwmQf7sQ+FzXt0Tw8a/KPTDd7AxmcTQjoI1o68z6Zbfmq3JAfI
        9geG/rTw=
X-Google-Smtp-Source: AMsMyM6pD7/1CfdXqj/jNvsCEXbeAqhoVu9Uyd4d36sH4okR02sUiuyQQnNgAkymlRretOQELMYE7w==
X-Received: by 2002:a05:6214:f04:b0:4b1:cb3b:79bd with SMTP id gw4-20020a0562140f0400b004b1cb3b79bdmr22163338qvb.22.1666476147196;
        Sat, 22 Oct 2022 15:02:27 -0700 (PDT)
Received: from linuxpc-ThinkServer-TS140.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i8-20020a05620a074800b006cea2984c9bsm11739295qki.100.2022.10.22.15.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Oct 2022 15:02:25 -0700 (PDT)
From:   Steven Hsieh <steven.hsieh@broadcom.com>
To:     Steven Hsieh <steven.hsieh@broadcom.com>
Cc:     Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] bonding: 3ad: bonding of links with different data rate
Date:   Sat, 22 Oct 2022 15:01:58 -0700
Message-Id: <20221022220158.74933-1-steven.hsieh@broadcom.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d087f505eba6b61e"
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000d087f505eba6b61e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Current Linux Bonding driver supports IEEE802.3ad-2000.
Operation across multiple data rates=E2=80=94
All links in a Link Aggregation Group operate at the same data rate.

In IEEE802.1AX-2014
Aggregation of links of different data rates is not prohibited
nor required by this standard.

This patch provides configuration option to allow aggregation of links
with different speed.

Enhancement is disabled by default and can be enabled thru
 echo 1 > /sys/class/net/bond*/bonding/async_linkspeed

Signed-off-by: Steven Hsieh <steven.hsieh@broadcom.com>

---

 drivers/net/bonding/bond_3ad.c     | 12 +++++++++++-
 drivers/net/bonding/bond_options.c | 26 ++++++++++++++++++++++++++
 drivers/net/bonding/bond_sysfs.c   | 15 +++++++++++++++
 include/net/bond_options.h         |  1 +
 include/net/bonding.h              |  1 +
 5 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.=
c
index e58a1e0cadd2..f5689dae88c3 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -385,6 +385,13 @@ static void __ad_actor_update_port(struct port *port)
 	port->actor_system_priority =3D BOND_AD_INFO(bond).system.sys_priority;
 }
=20
+static inline u32 __get_agg_async_linkspeed(struct port *port)
+{
+	const struct bonding *bond =3D bond_get_bond_by_slave(port->slave);
+
+	return (bond) ? bond->params.async_linkspeed : 0;
+}
+
 /* Conversions */
=20
 /**
@@ -2476,7 +2483,10 @@ static void ad_update_actor_keys(struct port *port, =
bool reset)
 		speed =3D __get_link_speed(port);
 		ospeed =3D (old_oper_key & AD_SPEED_KEY_MASKS) >> 1;
 		duplex =3D __get_duplex(port);
-		port->actor_admin_port_key |=3D (speed << 1) | duplex;
+		if (__get_agg_async_linkspeed(port))
+			port->actor_admin_port_key |=3D duplex;
+		else
+			port->actor_admin_port_key |=3D (speed << 1) | duplex;
 	}
 	port->actor_oper_port_key =3D port->actor_admin_port_key;
=20
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_=
options.c
index 3498db1c1b3c..cd871075b85c 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -84,6 +84,8 @@ static int bond_option_ad_user_port_key_set(struct bondin=
g *bond,
 					    const struct bond_opt_value *newval);
 static int bond_option_missed_max_set(struct bonding *bond,
 				      const struct bond_opt_value *newval);
+static int bond_option_async_linkspeed_set(struct bonding *bond,
+					   const struct bond_opt_value *newval);
=20
=20
 static const struct bond_opt_value bond_mode_tbl[] =3D {
@@ -226,6 +228,12 @@ static const struct bond_opt_value bond_missed_max_tbl=
[] =3D {
 	{ NULL,		-1,	0},
 };
=20
+static const struct bond_opt_value bond_async_linkspeed_tbl[] =3D {
+	{ "off", 0,  BOND_VALFLAG_DEFAULT},
+	{ "on",  1,  0},
+	{ NULL,  -1, 0},
+};
+
 static const struct bond_option bond_opts[BOND_OPT_LAST] =3D {
 	[BOND_OPT_MODE] =3D {
 		.id =3D BOND_OPT_MODE,
@@ -360,6 +368,14 @@ static const struct bond_option bond_opts[BOND_OPT_LAS=
T] =3D {
 		.values =3D bond_num_peer_notif_tbl,
 		.set =3D bond_option_num_peer_notif_set
 	},
+	[BOND_OPT_ASYNC_LINKSPEED] =3D {
+		.id =3D BOND_OPT_ASYNC_LINKSPEED,
+		.name =3D "async_linkspeed",
+		.desc =3D "Enable aggregation of links of different data rates",
+		.unsuppmodes =3D BOND_MODE_ALL_EX(BIT(BOND_MODE_8023AD)),
+		.values =3D bond_async_linkspeed_tbl,
+		.set =3D bond_option_async_linkspeed_set
+	},
 	[BOND_OPT_MIIMON] =3D {
 		.id =3D BOND_OPT_MIIMON,
 		.name =3D "miimon",
@@ -1702,3 +1718,13 @@ static int bond_option_ad_user_port_key_set(struct b=
onding *bond,
 	bond->params.ad_user_port_key =3D newval->value;
 	return 0;
 }
+
+static int bond_option_async_linkspeed_set(struct bonding *bond,
+					   const struct bond_opt_value *newval)
+{
+	netdev_info(bond->dev, "Setting async_linkspeed to %s (%llu)\n",
+		    newval->string, newval->value);
+	bond->params.async_linkspeed =3D newval->value;
+
+	return 0;
+}
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sy=
sfs.c
index 8996bd0a194a..6a0b4e1098af 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -753,6 +753,20 @@ static ssize_t bonding_show_ad_user_port_key(struct de=
vice *d,
 static DEVICE_ATTR(ad_user_port_key, 0644,
 		   bonding_show_ad_user_port_key, bonding_sysfs_store_option);
=20
+static ssize_t bonding_show_async_linkspeed(struct device *d,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct bonding *bond =3D to_bond(d);
+	const struct bond_opt_value *val;
+
+	val =3D bond_opt_get_val(BOND_OPT_ASYNC_LINKSPEED, bond->params.async_lin=
kspeed);
+
+	return sprintf(buf, "%s %d\n", val->string, bond->params.async_linkspeed)=
;
+}
+static DEVICE_ATTR(async_linkspeed, (00400 | 00040 | 00004) | 00200, /*S_I=
RUGO | S_IWUSR,*/
+		   bonding_show_async_linkspeed, bonding_sysfs_store_option);
+
 static struct attribute *per_bond_attrs[] =3D {
 	&dev_attr_slaves.attr,
 	&dev_attr_mode.attr,
@@ -792,6 +806,7 @@ static struct attribute *per_bond_attrs[] =3D {
 	&dev_attr_ad_actor_system.attr,
 	&dev_attr_ad_user_port_key.attr,
 	&dev_attr_arp_missed_max.attr,
+	&dev_attr_async_linkspeed.attr,
 	NULL,
 };
=20
diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index 69292ecc0325..5b33f8b3e1c7 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -76,6 +76,7 @@ enum {
 	BOND_OPT_MISSED_MAX,
 	BOND_OPT_NS_TARGETS,
 	BOND_OPT_PRIO,
+	BOND_OPT_ASYNC_LINKSPEED,
 	BOND_OPT_LAST
 };
=20
diff --git a/include/net/bonding.h b/include/net/bonding.h
index e999f851738b..5d83daab0669 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -146,6 +146,7 @@ struct bond_params {
 	int lp_interval;
 	int packets_per_slave;
 	int tlb_dynamic_lb;
+	int async_linkspeed;
 	struct reciprocal_value reciprocal_packets_per_slave;
 	u16 ad_actor_sys_prio;
 	u16 ad_user_port_key;
--=20
2.34.1


--=20
This electronic communication and the information and any files transmitted=
=20
with it, or attached to it, are confidential and are intended solely for=20
the use of the individual or entity to whom it is addressed and may contain=
=20
information that is confidential, legally privileged, protected by privacy=
=20
laws, or otherwise restricted from disclosure to anyone else. If you are=20
not the intended recipient or the person responsible for delivering the=20
e-mail to the intended recipient, you are hereby notified that any use,=20
copying, distributing, dissemination, forwarding, printing, or copying of=
=20
this e-mail is strictly prohibited. If you received this e-mail in error,=
=20
please return the e-mail to the sender, delete it from your computer, and=
=20
destroy any printed copy of it.

--000000000000d087f505eba6b61e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
zqFsDrDD6cfwPFA8egCLRqlqcMvTsLO8Ak8PulZSDNLvAbFQEcKXLzfSS5I4bJEyNm+gDxU2ufWn
S26/TTgra4hsvkgl1igpsKFbDqYd5GXc4f+GLIfWlFUCAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3RldmVuLmhzaWVoQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUo47KV++PjdaGX8yl9SYgLyqh
UFcwDQYJKoZIhvcNAQELBQADggEBACv8VBuGccogpklAkOkvfL8jtr7AUHpm2ZaG6RzE4EzvGTat
uzvVLmsDVHyVsa1ioxXjqCHYllCoea6lm9UEzsidojI+YYnkuh62tdBeZ7holVEdpaq39FmL1cdH
CSwbr9nedhgKPjQtcnY41wCwI1HMCUFiB3XW9DcBh94PSvqvYGsx0gFFJoXt2at06iqSLji8Rot+
jsXWHybl7AZDcupjJeQoApn6y0weM2xKcoG0WeN5SDDvmXTPe3AZG4n1xK1S8sjPJstMr++KiYS8
8l4ubZbXNKvsYhBY1PRITsrjcHkZbsufMbH2ZHAyxVN2QirJnb3Jocji5QBdKAX+pAAxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxJVhM6Swu/6EH/BMgw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGeW3sumG2nsq3hMUJONXeiOrCKSXQmf
0fKKaU82cgjrMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTAy
MjIyMDIyN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBUJQOtPyWifjf21KTNis7bQzcSo7SfWxPFCyg3PqKQ2q+GkCJr
r86h9BBxb0Lny+iYvy12RM0mRVEGioJKJMLO5e37/fQBleB3OwrTHqUFxu9fNcSeXksl1T/oVoeB
DPHWoGyWd0vQyUC15WAMc9JnacAqaEn0+xlHcQyaF6QjLDSKHvceSOq23WKLK3hFqpSUzFrILp+x
b2C3V/SlqMOaQJ/6Yf+mTBVZmO+YZuEZTFmbdSixl9PluAgevEc3N9vPO2IOZttmW90sCdN4HIT3
hctvbYoWIZi0FY6Z18adzpHfdLktpJ4x4jso3FZbezqDhFqpc+1UZ1Z8L086Vkd3
--000000000000d087f505eba6b61e--
