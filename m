Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BE82E79AD
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 14:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgL3N3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 08:29:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49934 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726918AbgL3N3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 08:29:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609334888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GXGC2Ug4+S7ej1DvToTvuYZtmEwFZdrTE0NrR0FI27A=;
        b=dKORO1sLGq6cJLQ4avZ6DGj/7/9eyDvxP09w0WmLKhgGWY2eNe0TtKuQH5FC4kk4RRsnae
        WkZf+4PLh6oz0fC54fO6AKyRJw9to/OMbAliG8NYlVOjweWgnvFgsTbxes57RQ2O9XgP9D
        q+2rkjZx3KHyJcnZBT+RzneHJ06ytQQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-3qiuA9bEPEW-GMbYctpTzg-1; Wed, 30 Dec 2020 08:28:04 -0500
X-MC-Unique: 3qiuA9bEPEW-GMbYctpTzg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C42B91005504;
        Wed, 30 Dec 2020 13:28:02 +0000 (UTC)
Received: from krava (unknown [10.40.192.129])
        by smtp.corp.redhat.com (Postfix) with SMTP id B488839A64;
        Wed, 30 Dec 2020 13:28:00 +0000 (UTC)
Date:   Wed, 30 Dec 2020 14:27:59 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Qais Yousef <qais.yousef@arm.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: BTFIDS: FAILED unresolved symbol udp6_sock
Message-ID: <20201230132759.GB577428@krava>
References: <20201229151352.6hzmjvu3qh6p2qgg@e107158-lin>
 <20201229173401.GH450923@krava>
 <20201229232835.cbyfmja3bu3lx7we@e107158-lin>
 <20201230090333.GA577428@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230090333.GA577428@krava>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 10:03:37AM +0100, Jiri Olsa wrote:
> On Tue, Dec 29, 2020 at 11:28:35PM +0000, Qais Yousef wrote:
> > Hi Jiri
> > 
> > On 12/29/20 18:34, Jiri Olsa wrote:
> > > On Tue, Dec 29, 2020 at 03:13:52PM +0000, Qais Yousef wrote:
> > > > Hi
> > > > 
> > > > When I enable CONFIG_DEBUG_INFO_BTF I get the following error in the BTFIDS
> > > > stage
> > > > 
> > > > 	FAILED unresolved symbol udp6_sock
> > > > 
> > > > I cross compile for arm64. My .config is attached.
> > > > 
> > > > I managed to reproduce the problem on v5.9 and v5.10. Plus 5.11-rc1.
> > > > 
> > > > Have you seen this before? I couldn't find a specific report about this
> > > > problem.
> > > > 
> > > > Let me know if you need more info.
> > > 
> > > hi,
> > > this looks like symptom of the gcc DWARF bug we were
> > > dealing with recently:
> > > 
> > >   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97060
> > >   https://lore.kernel.org/lkml/CAE1WUT75gu9G62Q9uAALGN6vLX=o7vZ9uhqtVWnbUV81DgmFPw@mail.gmail.com/#r
> > > 
> > > what pahole/gcc version are you using?
> > 
> > I'm on gcc 9.3.0
> > 
> > 	aarch64-linux-gnu-gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0
> > 
> > I was on pahole v1.17. I moved to v1.19 but I still see the same problem.
> 
> I can reproduce with your .config, but make 'defconfig' works,
> so I guess it's some config option issue, I'll check later today

so your .config has
  CONFIG_CRYPTO_DEV_BCM_SPU=y

and that defines 'struct device_private' which
clashes with the same struct defined in drivers/base/base.h

so several networking structs will be doubled, like net_device:

	$ bpftool btf dump file ../vmlinux.config | grep net_device\' | grep STRUCT
	[2731] STRUCT 'net_device' size=2240 vlen=133
	[113981] STRUCT 'net_device' size=2240 vlen=133

each is using different 'struct device_private' when it's unwinded

and that will confuse BTFIDS logic, becase we have multiple structs
with the same name, and we can't be sure which one to pick

perhaps we should check on this in pahole and warn earlier with
better error message.. I'll check, but I'm not sure if pahole can
survive another hastab ;-)

Andrii, any ideas on this? ;-)

easy fix is the patch below that renames the bcm's structs,
it makes the kernel to compile.. but of course the new name
is probably wrong and we should push this through that code
authors

jirka


---
diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 30390a7324b2..0e5537838ef3 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -42,7 +42,7 @@
 
 /* ================= Device Structure ================== */
 
-struct device_private iproc_priv;
+struct bcm_device_private iproc_priv;
 
 /* ==================== Parameters ===================== */
 
diff --git a/drivers/crypto/bcm/cipher.h b/drivers/crypto/bcm/cipher.h
index 0ad5892b445d..71281a3bdbdc 100644
--- a/drivers/crypto/bcm/cipher.h
+++ b/drivers/crypto/bcm/cipher.h
@@ -420,7 +420,7 @@ struct spu_hw {
 	u32 num_chan;
 };
 
-struct device_private {
+struct bcm_device_private {
 	struct platform_device *pdev;
 
 	struct spu_hw spu;
@@ -467,6 +467,6 @@ struct device_private {
 	struct mbox_chan **mbox;
 };
 
-extern struct device_private iproc_priv;
+extern struct bcm_device_private iproc_priv;
 
 #endif
diff --git a/drivers/crypto/bcm/util.c b/drivers/crypto/bcm/util.c
index 2b304fc78059..77aeedb84055 100644
--- a/drivers/crypto/bcm/util.c
+++ b/drivers/crypto/bcm/util.c
@@ -348,7 +348,7 @@ char *spu_alg_name(enum spu_cipher_alg alg, enum spu_cipher_mode mode)
 static ssize_t spu_debugfs_read(struct file *filp, char __user *ubuf,
 				size_t count, loff_t *offp)
 {
-	struct device_private *ipriv;
+	struct bcm_device_private *ipriv;
 	char *buf;
 	ssize_t ret, out_offset, out_count;
 	int i;

