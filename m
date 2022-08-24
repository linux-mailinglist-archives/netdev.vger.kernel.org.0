Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E15A59FBDF
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 15:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238646AbiHXNmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 09:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238605AbiHXNmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 09:42:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1A6832FE
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 06:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661348497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Cv9bxzwVz8NiyTj/f/mwFYM6BCcYIq17VnpuDmITas=;
        b=QUGGgVvWiJzcM/dnL/VcmLOb6IAXmk0c9ZJVRIkpIk603+uoBb1iDw0aWdXSlEDj/OufMm
        9BNkD3+JMZWyurkKe+ldlb5gBzSXsZfP0IrTwGvt2vAJlqGEtOfFwgIkp3CiEa4EY1d1Gp
        TTStM9QJ+Tn34L975ajoEmGEkjuwpiQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-PNIUO-MqP1m0vHmwVr-DEg-1; Wed, 24 Aug 2022 09:41:34 -0400
X-MC-Unique: PNIUO-MqP1m0vHmwVr-DEg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 676D518E530E;
        Wed, 24 Aug 2022 13:41:33 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35A809459C;
        Wed, 24 Aug 2022 13:41:30 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v9 09/23] HID: export hid_report_type to uapi
Date:   Wed, 24 Aug 2022 15:40:39 +0200
Message-Id: <20220824134055.1328882-10-benjamin.tissoires@redhat.com>
In-Reply-To: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we are dealing with eBPF, we need to have access to the report type.
Currently our implementation differs from the USB standard, making it
impossible for users to know the exact value besides hardcoding it
themselves.

And instead of a blank define, convert it as an enum.

Note that we need to also do change in the ll_driver API, but given
that this will have a wider impact outside of this tree, we leave this
as a TODO for the future.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

no changes in v9

no changes in v8

no changes in v7

changes in v6:
- add missing change for hid_hw_raw_request()

new in v5
---
 drivers/hid/hid-core.c   | 13 +++++++------
 include/linux/hid.h      | 24 ++++++++----------------
 include/uapi/linux/hid.h | 12 ++++++++++++
 3 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a00dd43db8bf..ab98754522d9 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -55,7 +55,7 @@ MODULE_PARM_DESC(ignore_special_drivers, "Ignore any special drivers and handle
  */
 
 struct hid_report *hid_register_report(struct hid_device *device,
-				       unsigned int type, unsigned int id,
+				       enum hid_report_type type, unsigned int id,
 				       unsigned int application)
 {
 	struct hid_report_enum *report_enum = device->report_enum + type;
@@ -967,7 +967,7 @@ static const char * const hid_report_names[] = {
  * parsing.
  */
 struct hid_report *hid_validate_values(struct hid_device *hid,
-				       unsigned int type, unsigned int id,
+				       enum hid_report_type type, unsigned int id,
 				       unsigned int field_index,
 				       unsigned int report_counts)
 {
@@ -1954,8 +1954,8 @@ int __hid_request(struct hid_device *hid, struct hid_report *report,
 }
 EXPORT_SYMBOL_GPL(__hid_request);
 
-int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, u32 size,
-		int interrupt)
+int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *data, u32 size,
+			 int interrupt)
 {
 	struct hid_report_enum *report_enum = hid->report_enum + type;
 	struct hid_report *report;
@@ -2019,7 +2019,8 @@ EXPORT_SYMBOL_GPL(hid_report_raw_event);
  *
  * This is data entry for lower layers.
  */
-int hid_input_report(struct hid_device *hid, int type, u8 *data, u32 size, int interrupt)
+int hid_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data, u32 size,
+		     int interrupt)
 {
 	struct hid_report_enum *report_enum;
 	struct hid_driver *hdrv;
@@ -2377,7 +2378,7 @@ EXPORT_SYMBOL_GPL(hid_hw_request);
  */
 int hid_hw_raw_request(struct hid_device *hdev,
 		       unsigned char reportnum, __u8 *buf,
-		       size_t len, unsigned char rtype, int reqtype)
+		       size_t len, enum hid_report_type rtype, int reqtype)
 {
 	if (len < 1 || len > HID_MAX_BUFFER_SIZE || !buf)
 		return -EINVAL;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index a43dd17bc78f..b1a33dbbc78e 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -314,15 +314,6 @@ struct hid_item {
 #define HID_BAT_ABSOLUTESTATEOFCHARGE	0x00850065
 
 #define HID_VD_ASUS_CUSTOM_MEDIA_KEYS	0xff310076
-/*
- * HID report types --- Ouch! HID spec says 1 2 3!
- */
-
-#define HID_INPUT_REPORT	0
-#define HID_OUTPUT_REPORT	1
-#define HID_FEATURE_REPORT	2
-
-#define HID_REPORT_TYPES	3
 
 /*
  * HID connect requests
@@ -509,7 +500,7 @@ struct hid_report {
 	struct list_head hidinput_list;
 	struct list_head field_entry_list;		/* ordered list of input fields */
 	unsigned int id;				/* id of this report */
-	unsigned int type;				/* report type */
+	enum hid_report_type type;			/* report type */
 	unsigned int application;			/* application usage for this report */
 	struct hid_field *field[HID_MAX_FIELDS];	/* fields of the report */
 	struct hid_field_entry *field_entries;		/* allocated memory of input field_entry */
@@ -926,7 +917,8 @@ extern int hidinput_connect(struct hid_device *hid, unsigned int force);
 extern void hidinput_disconnect(struct hid_device *);
 
 int hid_set_field(struct hid_field *, unsigned, __s32);
-int hid_input_report(struct hid_device *, int type, u8 *, u32, int);
+int hid_input_report(struct hid_device *hid, enum hid_report_type type, u8 *data, u32 size,
+		     int interrupt);
 struct hid_field *hidinput_get_led_field(struct hid_device *hid);
 unsigned int hidinput_count_leds(struct hid_device *hid);
 __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code);
@@ -935,11 +927,11 @@ int __hid_request(struct hid_device *hid, struct hid_report *rep, int reqtype);
 u8 *hid_alloc_report_buf(struct hid_report *report, gfp_t flags);
 struct hid_device *hid_allocate_device(void);
 struct hid_report *hid_register_report(struct hid_device *device,
-				       unsigned int type, unsigned int id,
+				       enum hid_report_type type, unsigned int id,
 				       unsigned int application);
 int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size);
 struct hid_report *hid_validate_values(struct hid_device *hid,
-				       unsigned int type, unsigned int id,
+				       enum hid_report_type type, unsigned int id,
 				       unsigned int field_index,
 				       unsigned int report_counts);
 
@@ -1111,7 +1103,7 @@ void hid_hw_request(struct hid_device *hdev,
 		    struct hid_report *report, int reqtype);
 int hid_hw_raw_request(struct hid_device *hdev,
 		       unsigned char reportnum, __u8 *buf,
-		       size_t len, unsigned char rtype, int reqtype);
+		       size_t len, enum hid_report_type rtype, int reqtype);
 int hid_hw_output_report(struct hid_device *hdev, __u8 *buf, size_t len);
 
 /**
@@ -1184,8 +1176,8 @@ static inline u32 hid_report_len(struct hid_report *report)
 	return DIV_ROUND_UP(report->size, 8) + (report->id > 0);
 }
 
-int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, u32 size,
-		int interrupt);
+int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *data, u32 size,
+			 int interrupt);
 
 /* HID quirks API */
 unsigned long hid_lookup_quirk(const struct hid_device *hdev);
diff --git a/include/uapi/linux/hid.h b/include/uapi/linux/hid.h
index b34492a87a8a..b25b0bacaff2 100644
--- a/include/uapi/linux/hid.h
+++ b/include/uapi/linux/hid.h
@@ -42,6 +42,18 @@
 #define USB_INTERFACE_PROTOCOL_KEYBOARD	1
 #define USB_INTERFACE_PROTOCOL_MOUSE	2
 
+/*
+ * HID report types --- Ouch! HID spec says 1 2 3!
+ */
+
+enum hid_report_type {
+	HID_INPUT_REPORT		= 0,
+	HID_OUTPUT_REPORT		= 1,
+	HID_FEATURE_REPORT		= 2,
+
+	HID_REPORT_TYPES,
+};
+
 /*
  * HID class requests
  */
-- 
2.36.1

