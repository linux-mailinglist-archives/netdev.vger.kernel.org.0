Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612412AF2F8
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 15:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbgKKODa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 09:03:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727233AbgKKODV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 09:03:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605103400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9esnXIxru8+RNVWB1D49REf+6KCKaBBBFOJUSavGUik=;
        b=DoiiZEoL721YBNYD2oBITq1/j4p+rqghryGDi2VxcXc5F4dXAs+cnYYv67uy01dwVhQXI0
        afMbXRTMX3Ze+Do17m5DmpUIXzrolF8tbQho7meT8pLFfvWeouQYBUeitUY3h7wicAp2vc
        9zTFIkLLsG5Tf/TnpGxo92KDAoWqn0E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-nXoT7eWxMHiz0r_o4PNLwA-1; Wed, 11 Nov 2020 09:03:17 -0500
X-MC-Unique: nXoT7eWxMHiz0r_o4PNLwA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6FC51017DC8;
        Wed, 11 Nov 2020 14:03:15 +0000 (UTC)
Received: from ovpn-66-204.rdu2.redhat.com (ovpn-66-204.rdu2.redhat.com [10.10.66.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF6085DA74;
        Wed, 11 Nov 2020 14:03:14 +0000 (UTC)
Message-ID: <288207f247a2e1c6c7940f87e337d3b881c7de17.camel@redhat.com>
Subject: Re: linux-next: build warning after merge of the bpf-next tree
From:   Qian Cai <cai@redhat.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Date:   Wed, 11 Nov 2020 09:03:14 -0500
In-Reply-To: <20201111120121.48dd970d@canb.auug.org.au>
References: <20201111120121.48dd970d@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-11 at 12:01 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the bpf-next tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> kernel/bpf/btf.c:4481:20: warning: 'btf_parse_module' defined but not used [-
> Wunused-function]
>  4481 | static struct btf *btf_parse_module(const char *module_name, const
> void *data, unsigned int data_size)
>       |                    ^~~~~~~~~~~~~~~~
> 
> Introduced by commit
> 
>   36e68442d1af ("bpf: Load and verify kernel module BTFs")
> 

It loos like btf_parse_module() is only used when
CONFIG_DEBUG_INFO_BTF_MODULES=y, so this should fix it.

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 0f1fd2669d69..e877eeebc616 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4478,6 +4478,7 @@ struct btf *btf_parse_vmlinux(void)
 	return ERR_PTR(err);
 }
 
+#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 static struct btf *btf_parse_module(const char *module_name, const void *data, unsigned int data_size)
 {
 	struct btf_verifier_env *env = NULL;
@@ -4546,6 +4547,7 @@ static struct btf *btf_parse_module(const char *module_name, const void *data, u
 	}
 	return ERR_PTR(err);
 }
+#endif /* CONFIG_DEBUG_INFO_BTF_MODULES */
 
 struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog)
 {

