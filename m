Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A9C6483D0
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 15:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiLIOal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 09:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiLIOaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 09:30:30 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8E132BB7;
        Fri,  9 Dec 2022 06:30:27 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id vp12so11887423ejc.8;
        Fri, 09 Dec 2022 06:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cuA2yPf+ChfcfCglv6Ul1/eHJRw+DDn5TeyeY8RCIMk=;
        b=XZ5aiS7J0L0YcnighJH4FbLcZQdAWCgk+XRT3yyaxd6yTQ2N1iR/NFMH3zc5oxoqyK
         O2kdbDTlwT+kQgh31FJD6v7IRSY9cEwDemh0TDy4M9PNzmJnP4tdLbNTL6NEppFYZrii
         idbE8Zc8W7KNK0WiNX2gF7XohHE1dE6K92a7aqMgXl3D0W5guFQ39loq1diDLsBpRD48
         XwTEb5ir38Fx+fqf9lq7RhWtwNczI15clq6l9/LG09rOVrO2yOe5jVZqGc2SR4q1PhWI
         PUzkgCoFEBMy3OBqcSZ+fCG9OTfcq9Qth4kFA8NfJ/NgRV7F/dE5U9W+jN0itIDueSlc
         N6VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cuA2yPf+ChfcfCglv6Ul1/eHJRw+DDn5TeyeY8RCIMk=;
        b=qQtfoP0GA99ikHE5gsiLEdyPDVj1sJxtYmoST+yyPCHA3sfBK1VEC4ndHmoek9FD0V
         u86z6o65SDyoPN0eeRHpPEwM0hdLuxtp4YjvUqTkmQLP6Agr9DpSYEsBAqkjieypiBgP
         6uyfePl2Wp10Hbk17twSJ/iD4jcDc1Px7dIP8vzk20Qa3jz80kxq28J6VhBegtEx07yr
         dUGwnCV9nquD1D09hbqU+3/450UTsrATKlE+aHlfkzxb7b5+6r6/Km4UAkXOKyXV9klY
         B653hD9oJY+mQpcUpZG187HuBGQNyudNI4RNHaODZ9/By0YnjIE0SO8dN/VE0aQ45UHN
         +0gQ==
X-Gm-Message-State: ANoB5plWhu2o89jJ+39qkAwkAokyajK8G34nveaSHCYyf3hZWjtdUsfj
        aOhABEm23CjWZ2SkpXDbqYw=
X-Google-Smtp-Source: AA0mqf6a9KtAVVGSdOmc+5oXWjX8CuVNvMLv6UohalkXgvPQqtSu54aECYaS+1SuFdcWvyygfurYyQ==
X-Received: by 2002:a17:907:9712:b0:78d:f459:7186 with SMTP id jg18-20020a170907971200b0078df4597186mr10344136ejc.49.1670596226850;
        Fri, 09 Dec 2022 06:30:26 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id fu38-20020a170907b02600b007ae32daf4b9sm621192ejc.106.2022.12.09.06.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 06:30:26 -0800 (PST)
Date:   Fri, 9 Dec 2022 16:30:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Uladzislau Koshchanka <koshchanka@gmail.com>
Cc:     Dan Carpenter <error27@gmail.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] lib: packing: fix shift wrapping in bit_reverse()
Message-ID: <20221209143024.ad4cckonv4c3yhxd@skbuf>
References: <Y5B3sAcS6qKSt+lS@kili>
 <CAHktU2C00J7wY5uDbbScxwb0fD2kwUH+-=hgS5o_Timemh0Auw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHktU2C00J7wY5uDbbScxwb0fD2kwUH+-=hgS5o_Timemh0Auw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uladzislau,

On Fri, Dec 09, 2022 at 11:21:21AM +0300, Uladzislau Koshchanka wrote:
> On Wed, 7 Dec 2022 at 14:30, Dan Carpenter <error27@gmail.com> wrote:
> >
> > The bit_reverse() function is clearly supposed to be able to handle
> > 64 bit values, but the types for "(1 << i)" and "bit << (width - i - 1)"
> > are not enough to handle more than 32 bits.
> 
> It seems from the surrounding code that this function is only called
> for width of up to a byte (but correct me if I'm wrong).

This observation is quite true. I was quite lazy to look and remember
whether this is the case, but the comment says it quite clearly:

		/* Bit indices into the currently accessed 8-bit box */
		int box_start_bit, box_end_bit, box_addr;

> There are fast implementations of bit-reverse in include/linux/bitrev.h.
> It's better to just remove this function entirely and call bitrev8,
> which is just a precalc-table lookup. While at it, also sort includes.

The problem I see with bitrev8 is that the byte_rev_table[] can
seemingly be built as a module (the BITREVERSE Kconfig knob is tristate,
and btw your patch doesn't make PACKING select BITREVERSE). But PACKING
is bool. IIRC, I got comments during review that it's not worth making
packing a module, but I may remember wrong.

> @@ -49,7 +37,7 @@ static void adjust_for_msb_right_quirk(u64
> *to_write, int *box_start_bit,
>         int new_box_start_bit, new_box_end_bit;
> 
>         *to_write >>= *box_end_bit;
> -       *to_write = bit_reverse(*to_write, box_bit_width);
> +       *to_write = bitrev8(*to_write) >> (8 - box_bit_width);
>         *to_write <<= *box_end_bit;
> 
>         new_box_end_bit   = box_bit_width - *box_start_bit - 1;

Anyway, the patch works in principle. I know this because I wrote the
following patch to check:

From 17099a86291713d2bcf8137473daea5f390a2ef4 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Fri, 9 Dec 2022 16:23:35 +0200
Subject: [PATCH] lib: packing: add boot-time selftests

In case people want to make changes to the packing() implementation but
they aren't sure it's going to keep working, provide 16 boot-time calls
to packing() which exercise all combinations of quirks plus PACK |
UNPACK.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 lib/Kconfig   |   9 +++
 lib/packing.c | 186 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 195 insertions(+)

diff --git a/lib/Kconfig b/lib/Kconfig
index 9bbf8a4b2108..54b8deaf44fc 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -39,6 +39,15 @@ config PACKING
 
 	  When in doubt, say N.
 
+config PACKING_SELFTESTS
+	bool "Selftests for packing library"
+	depends on PACKING
+	help
+	  Boot-time selftests to make sure that the packing and unpacking
+	  functions work properly.
+
+	  When in doubt, say N.
+
 config BITREVERSE
 	tristate
 
diff --git a/lib/packing.c b/lib/packing.c
index 9a72f4bbf0e2..aff70853b0c4 100644
--- a/lib/packing.c
+++ b/lib/packing.c
@@ -210,5 +210,191 @@ int packing(void *pbuf, u64 *uval, int startbit, int endbit, size_t pbuflen,
 }
 EXPORT_SYMBOL(packing);
 
+#if IS_ENABLED(CONFIG_PACKING_SELFTESTS)
+
+#define PBUF_LEN 16
+
+/* These selftests pack and unpack a magic 64-bit value (0xcafedeadbeefcafe) at
+ * a fixed logical offset (32) within an otherwise zero array of 128 bits
+ * (16 bytes). They test all possible bit layouts of the 128 bit buffer.
+ */
+static bool test_pack(u8 expected_pbuf[PBUF_LEN], u8 quirks)
+{
+	u64 uval = 0xcafedeadbeefcafe;
+	u8 pbuf[PBUF_LEN];
+	int err, i;
+
+	memset(pbuf, 0, PBUF_LEN);
+	err = packing(pbuf, &uval, 95, 32, PBUF_LEN, PACK, quirks);
+	if (err) {
+		pr_err("packing() returned %pe\n", ERR_PTR(err));
+		return false;
+	}
+
+	for (i = 0; i < PBUF_LEN; i++) {
+		if (pbuf[i] != expected_pbuf[i]) {
+			print_hex_dump(KERN_ERR, "pbuf:     ", DUMP_PREFIX_NONE,
+				       16, 1, pbuf, PBUF_LEN, false);
+			print_hex_dump(KERN_ERR, "expected: ", DUMP_PREFIX_NONE,
+				       16, 1, expected_pbuf, PBUF_LEN, false);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static bool test_unpack(u8 pbuf[PBUF_LEN], u8 quirks)
+{
+	u64 uval, expected_uval = 0xcafedeadbeefcafe;
+	int err;
+
+	err = packing(pbuf, &uval, 95, 32, PBUF_LEN, UNPACK, quirks);
+	if (err) {
+		pr_err("packing() returned %pe\n", ERR_PTR(err));
+		return false;
+	}
+
+	if (uval != expected_uval) {
+		pr_err("uval: 0x%llx expected 0x%llx\n", uval, expected_uval);
+		return false;
+	}
+
+	return true;
+}
+
+static void test_no_quirks(void)
+{
+	u8 pbuf[PBUF_LEN] = {0x00, 0x00, 0x00, 0x00, 0xca, 0xfe, 0xde, 0xad,
+			     0xbe, 0xef, 0xca, 0xfe, 0x00, 0x00, 0x00, 0x00};
+	bool ret;
+
+	ret = test_pack(pbuf, 0);
+	pr_info("packing with no quirks: %s\n", ret ? "OK" : "FAIL");
+
+	ret = test_unpack(pbuf, 0);
+	pr_info("unpacking with no quirks: %s\n", ret ? "OK" : "FAIL");
+}
+
+static void test_msb_right(void)
+{
+	u8 pbuf[PBUF_LEN] = {0x00, 0x00, 0x00, 0x00, 0x53, 0x7f, 0x7b, 0xb5,
+			     0x7d, 0xf7, 0x53, 0x7f, 0x00, 0x00, 0x00, 0x00};
+	bool ret;
+
+	ret = test_pack(pbuf, QUIRK_MSB_ON_THE_RIGHT);
+	pr_info("packing with QUIRK_MSB_ON_THE_RIGHT: %s\n",
+		ret ? "OK" : "FAIL");
+
+	ret = test_unpack(pbuf, QUIRK_MSB_ON_THE_RIGHT);
+	pr_info("unpacking with QUIRK_MSB_ON_THE_RIGHT: %s\n",
+		ret ? "OK" : "FAIL");
+}
+
+static void test_le(void)
+{
+	u8 pbuf[PBUF_LEN] = {0x00, 0x00, 0x00, 0x00, 0xad, 0xde, 0xfe, 0xca,
+			     0xfe, 0xca, 0xef, 0xbe, 0x00, 0x00, 0x00, 0x00};
+	bool ret;
+
+	ret = test_pack(pbuf, QUIRK_LITTLE_ENDIAN);
+	pr_info("packing with QUIRK_LITTLE_ENDIAN: %s\n", ret ? "OK" : "FAIL");
+
+	ret = test_unpack(pbuf, QUIRK_LITTLE_ENDIAN);
+	pr_info("unpacking with QUIRK_LITTLE_ENDIAN: %s\n",
+		ret ? "OK" : "FAIL");
+}
+
+static void test_le_msb_right(void)
+{
+	u8 pbuf[PBUF_LEN] = {0x00, 0x00, 0x00, 0x00, 0xb5, 0x7b, 0x7f, 0x53,
+			     0x7f, 0x53, 0xf7, 0x7d, 0x00, 0x00, 0x00, 0x00};
+	bool ret;
+
+	ret = test_pack(pbuf, QUIRK_LITTLE_ENDIAN | QUIRK_MSB_ON_THE_RIGHT);
+	pr_info("packing with QUIRK_LITTLE_ENDIAN | QUIRK_MSB_ON_THE_RIGHT: %s\n",
+		ret ? "OK" : "FAIL");
+
+	ret = test_unpack(pbuf, QUIRK_LITTLE_ENDIAN | QUIRK_MSB_ON_THE_RIGHT);
+	pr_info("unpacking with QUIRK_LITTLE_ENDIAN | QUIRK_MSB_ON_THE_RIGHT: %s\n",
+		ret ? "OK" : "FAIL");
+}
+
+static void test_lsw32_first(void)
+{
+	u8 pbuf[PBUF_LEN] = {0x00, 0x00, 0x00, 0x00, 0xbe, 0xef, 0xca, 0xfe,
+			     0xca, 0xfe, 0xde, 0xad, 0x00, 0x00, 0x00, 0x00};
+	bool ret;
+
+	ret = test_pack(pbuf, QUIRK_LSW32_IS_FIRST);
+	pr_info("packing with QUIRK_LSW32_IS_FIRST: %s\n", ret ? "OK" : "FAIL");
+
+	ret = test_unpack(pbuf, QUIRK_LSW32_IS_FIRST);
+	pr_info("unpacking with QUIRK_LSW32_IS_FIRST: %s\n", ret ? "OK" : "FAIL");
+}
+
+static void test_lsw32_first_msb_right(void)
+{
+	u8 pbuf[PBUF_LEN] = {0x00, 0x00, 0x00, 0x00, 0x7d, 0xf7, 0x53, 0x7f,
+			     0x53, 0x7f, 0x7b, 0xb5, 0x00, 0x00, 0x00, 0x00};
+	bool ret;
+
+	ret = test_pack(pbuf, QUIRK_LSW32_IS_FIRST | QUIRK_MSB_ON_THE_RIGHT);
+	pr_info("packing with QUIRK_LSW32_IS_FIRST | QUIRK_MSB_ON_THE_RIGHT: %s\n",
+		ret ? "OK" : "FAIL");
+
+	ret = test_unpack(pbuf, QUIRK_LSW32_IS_FIRST | QUIRK_MSB_ON_THE_RIGHT);
+	pr_info("unpacking with QUIRK_LSW32_IS_FIRST | QUIRK_MSB_ON_THE_RIGHT: %s\n",
+		ret ? "OK" : "FAIL");
+}
+
+static void test_lsw32_first_le(void)
+{
+	u8 pbuf[PBUF_LEN] = {0x00, 0x00, 0x00, 0x00, 0xfe, 0xca, 0xef, 0xbe,
+			     0xad, 0xde, 0xfe, 0xca, 0x00, 0x00, 0x00, 0x00};
+	bool ret;
+
+	ret = test_pack(pbuf, QUIRK_LSW32_IS_FIRST | QUIRK_LITTLE_ENDIAN);
+	pr_info("packing with QUIRK_LSW32_IS_FIRST | QUIRK_LITTLE_ENDIAN: %s\n",
+		ret ? "OK" : "FAIL");
+
+	ret = test_unpack(pbuf, QUIRK_LSW32_IS_FIRST | QUIRK_LITTLE_ENDIAN);
+	pr_info("unpacking with QUIRK_LSW32_IS_FIRST | QUIRK_LITTLE_ENDIAN: %s\n",
+		ret ? "OK" : "FAIL");
+}
+
+static void test_lsw32_first_le_msb_right(void)
+{
+	u8 pbuf[PBUF_LEN] = {0x00, 0x00, 0x00, 0x00, 0x7f, 0x53, 0xf7, 0x7d,
+			     0xb5, 0x7b, 0x7f, 0x53, 0x00, 0x00, 0x00, 0x00};
+	bool ret;
+
+	ret = test_pack(pbuf, QUIRK_LSW32_IS_FIRST | QUIRK_LITTLE_ENDIAN |
+			QUIRK_MSB_ON_THE_RIGHT);
+	pr_info("packing with QUIRK_LSW32_IS_FIRST | QUIRK_LITTLE_ENDIAN | QUIRK_MSB_ON_THE_RIGHT: %s\n",
+		ret ? "OK" : "FAIL");
+
+	ret = test_unpack(pbuf, QUIRK_LSW32_IS_FIRST | QUIRK_LITTLE_ENDIAN |
+			  QUIRK_MSB_ON_THE_RIGHT);
+	pr_info("unpacking with QUIRK_LSW32_IS_FIRST | QUIRK_LITTLE_ENDIAN | QUIRK_MSB_ON_THE_RIGHT: %s\n",
+		ret ? "OK" : "FAIL");
+}
+
+static int __init packing_init(void)
+{
+	test_no_quirks();
+	test_msb_right();
+	test_le();
+	test_le_msb_right();
+	test_lsw32_first();
+	test_lsw32_first_msb_right();
+	test_lsw32_first_le();
+	test_lsw32_first_le_msb_right();
+
+	return 0;
+}
+module_init(packing_init);
+#endif
+
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Generic bitfield packing and unpacking");
-- 
2.34.1


I've been meaning to do this for a while, but I'm not sure what is the
best way to integrate such a thing. Does anyone have any idea?
