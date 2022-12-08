Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611156478CD
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 23:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiLHW36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 17:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLHW34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 17:29:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7476B80A2D
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 14:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670538541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FhK6lrzIgiH8hbaudfNms9E+O1KaqKAcAcJvqf0/xmc=;
        b=YN+PmybUi22pmVb6gNSvrtHecE7tz3XZ883hXJssk7rWVNvv00ZA64tby1Pi6A1esal4iU
        Y5ufLiusztJ0L8DXKdabJtZ+fog6GPfUmv6zG34XY1ccG1h+U6NP+apn783grS4I7IZTyi
        4G6up/SMBj/lXp/AFlIUymNYOrEc1Ss=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-144-_taHrSrYOYaqarvJB-o2lQ-1; Thu, 08 Dec 2022 17:28:57 -0500
X-MC-Unique: _taHrSrYOYaqarvJB-o2lQ-1
Received: by mail-ej1-f69.google.com with SMTP id sb2-20020a1709076d8200b007bdea97e799so1927683ejc.22
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 14:28:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FhK6lrzIgiH8hbaudfNms9E+O1KaqKAcAcJvqf0/xmc=;
        b=OzCJVrFUfSocFciTPIz2Icz1tXy/BRjJBXy0EuWRXquYPItp+FA1RgrzBUqig88VAg
         /hHfyv89Xa0FA3qnd63SNshqKJJ0oiAPAWeJu1HCixj0NHKCBcpte7zlXf/vIXkxuJ/d
         I/iG8tOdJyRZddF1De+irUQh1m1Yi989nm0nEtKq7SY4UiFQabYLW+yeEetdRbKey4se
         UvYuz1jz6gR93CVLHIhTEWXX/wvK1NL5PxUnzxhZP8L1BX5peZUfqGs0yWw8lrZQtS4+
         TemGDEabBhBG+pylzwRRhhnlYdD4Nl1nJK/ybIxaSdON7tWlRalpGe1K0Ik697TdtBuq
         kuPA==
X-Gm-Message-State: ANoB5pkmhr8NubZPPUIxay9C2Tg/DyO0Grh96s/Foq9yIfztnnLUp5F1
        2brD3ZSWxPK9EAI5aqSSvVdzmHyFYtCR1jvu02aTzeQRV+RYdp+4XJhlwQ5h6H0kEq07GRNWsBh
        6hYKC34qQSxZ4lsFT
X-Received: by 2002:aa7:d28d:0:b0:46c:aa7a:bd3f with SMTP id w13-20020aa7d28d000000b0046caa7abd3fmr3062345edq.23.1670538535917;
        Thu, 08 Dec 2022 14:28:55 -0800 (PST)
X-Google-Smtp-Source: AA0mqf61+M9kU7f1HY4zoOSSRmxCiOeNg/H19gc1OBddIV6EKQL/UgDZtPf2Y2XuLzrt4Ph0Ux4V5A==
X-Received: by 2002:aa7:d28d:0:b0:46c:aa7a:bd3f with SMTP id w13-20020aa7d28d000000b0046caa7abd3fmr3062303edq.23.1670538534700;
        Thu, 08 Dec 2022 14:28:54 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id n19-20020a05640205d300b0046bf4935323sm3914802edx.30.2022.12.08.14.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 14:28:54 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 541DC82E99F; Thu,  8 Dec 2022 23:28:53 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] [PATCH bpf-next v3 00/12] xdp: hints via kfuncs
In-Reply-To: <20221206024554.3826186-1-sdf@google.com>
References: <20221206024554.3826186-1-sdf@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 08 Dec 2022 23:28:53 +0100
Message-ID: <87bkodleca.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> Please see the first patch in the series for the overall
> design and use-cases.
>
> Changes since v3:
>
> - Rework prog->bound_netdev refcounting (Jakub/Marin)
>
>   Now it's based on the offload.c framework. It mostly fits, except
>   I had to automatically insert a HT entry for the netdev. In the
>   offloaded case, the netdev is added via a call to
>   bpf_offload_dev_netdev_register from the driver init path; with
>   a dev-bound programs, we have to manually add (and remove) the entry.
>
>   As suggested by Toke, I'm also prohibiting putting dev-bound programs
>   into prog-array map; essentially prohibiting tail calling into it.
>   I'm also disabling freplace of the dev-bound programs. Both of those
>   restrictions can be loosened up eventually.

I thought it would be a shame that we don't support at least freplace
programs from the get-go (as that would exclude libxdp from taking
advantage of this). So see below for a patch implementing this :)

-Toke




commit 3abb333e5fd2e8a0920b77013499bdae0ee3db43
Author: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
Date:   Thu Dec 8 23:10:54 2022 +0100

    bpf: Support consuming XDP HW metadata from fext programs
=20=20=20=20
    Instead of rejecting the attaching of PROG_TYPE_EXT programs to XDP
    programs that consume HW metadata, implement support for propagating the
    offload information. The extension program doesn't need to set a flag or
    ifindex, it these will just be propagated from the target by the verifi=
er.
    We need to create a separate offload object for the extension program,
    though, since it can be reattached to a different program later (which
    means we can't just inhering the offload information from the target).
=20=20=20=20
    An additional check is added on attach that the new target is compatible
    with the offload information in the extension prog.
=20=20=20=20
    Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index b46b60f4eae1..cfa5c847cf2c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2482,6 +2482,7 @@ void *bpf_offload_resolve_kfunc(struct bpf_prog *prog=
, u32 func_id);
 void unpriv_ebpf_notify(int new_state);
=20
 #if defined(CONFIG_NET) && defined(CONFIG_BPF_SYSCALL)
+int __bpf_prog_offload_init(struct bpf_prog *prog, struct net_device *netd=
ev);
 int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr);
 void bpf_offload_bound_netdev_unregister(struct net_device *dev);
=20
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index bad8bab916eb..b059a7b53457 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -83,36 +83,25 @@ bpf_offload_find_netdev(struct net_device *netdev)
 	return rhashtable_lookup_fast(&offdevs, &netdev, offdevs_params);
 }
=20
-int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
+int __bpf_prog_offload_init(struct bpf_prog *prog, struct net_device *netd=
ev)
 {
 	struct bpf_offload_netdev *ondev;
 	struct bpf_prog_offload *offload;
 	int err;
=20
-	if (attr->prog_type !=3D BPF_PROG_TYPE_SCHED_CLS &&
-	    attr->prog_type !=3D BPF_PROG_TYPE_XDP)
+	if (!netdev)
 		return -EINVAL;
=20
-	if (attr->prog_flags & ~BPF_F_XDP_HAS_METADATA)
-		return -EINVAL;
+	err =3D __bpf_offload_init();
+	if (err)
+		return err;
=20
 	offload =3D kzalloc(sizeof(*offload), GFP_USER);
 	if (!offload)
 		return -ENOMEM;
=20
-	err =3D __bpf_offload_init();
-	if (err)
-		return err;
-
 	offload->prog =3D prog;
-
-	offload->netdev =3D dev_get_by_index(current->nsproxy->net_ns,
-					   attr->prog_ifindex);
-	err =3D bpf_dev_offload_check(offload->netdev);
-	if (err)
-		goto err_maybe_put;
-
-	prog->aux->offload_requested =3D !(attr->prog_flags & BPF_F_XDP_HAS_METAD=
ATA);
+	offload->netdev =3D netdev;
=20
 	down_write(&bpf_devs_lock);
 	ondev =3D bpf_offload_find_netdev(offload->netdev);
@@ -135,19 +124,46 @@ int bpf_prog_offload_init(struct bpf_prog *prog, unio=
n bpf_attr *attr)
 	offload->offdev =3D ondev->offdev;
 	prog->aux->offload =3D offload;
 	list_add_tail(&offload->offloads, &ondev->progs);
-	dev_put(offload->netdev);
 	up_write(&bpf_devs_lock);
=20
 	return 0;
 err_unlock:
 	up_write(&bpf_devs_lock);
-err_maybe_put:
-	if (offload->netdev)
-		dev_put(offload->netdev);
 	kfree(offload);
 	return err;
 }
=20
+int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
+{
+	struct net_device *netdev;
+	int err;
+
+	if (attr->prog_type !=3D BPF_PROG_TYPE_SCHED_CLS &&
+	    attr->prog_type !=3D BPF_PROG_TYPE_XDP)
+		return -EINVAL;
+
+	if (attr->prog_flags & ~BPF_F_XDP_HAS_METADATA)
+		return -EINVAL;
+
+	netdev =3D dev_get_by_index(current->nsproxy->net_ns, attr->prog_ifindex);
+	if (!netdev)
+		return -EINVAL;
+
+	err =3D bpf_dev_offload_check(netdev);
+	if (err)
+		goto out;
+
+	prog->aux->offload_requested =3D !(attr->prog_flags & BPF_F_XDP_HAS_METAD=
ATA);
+
+	err =3D __bpf_prog_offload_init(prog, netdev);
+	if (err)
+		goto out;
+
+out:
+	dev_put(netdev);
+	return err;
+}
+
 int bpf_prog_offload_verifier_prep(struct bpf_prog *prog)
 {
 	struct bpf_prog_offload *offload;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b345a273f7d0..606e6de5f716 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3021,6 +3021,14 @@ static int bpf_tracing_prog_attach(struct bpf_prog *=
prog,
 			goto out_put_prog;
 		}
=20
+		if (bpf_prog_is_dev_bound(tgt_prog->aux) &&
+		    (bpf_prog_is_offloaded(tgt_prog->aux) ||
+		     !bpf_prog_is_dev_bound(prog->aux) ||
+		     !bpf_offload_dev_match(prog, tgt_prog->aux->offload->netdev))) {
+			err =3D -EINVAL;
+			goto out_put_prog;
+		}
+
 		key =3D bpf_trampoline_compute_key(tgt_prog, NULL, btf_id);
 	}
=20
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index bc8d9b8d4f47..d92e28dd220e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -16379,11 +16379,6 @@ int bpf_check_attach_target(struct bpf_verifier_lo=
g *log,
 	if (tgt_prog) {
 		struct bpf_prog_aux *aux =3D tgt_prog->aux;
=20
-		if (bpf_prog_is_dev_bound(tgt_prog->aux)) {
-			bpf_log(log, "Replacing device-bound programs not supported\n");
-			return -EINVAL;
-		}
-
 		for (i =3D 0; i < aux->func_info_cnt; i++)
 			if (aux->func_info[i].type_id =3D=3D btf_id) {
 				subprog =3D i;
@@ -16644,10 +16639,22 @@ static int check_attach_btf_id(struct bpf_verifie=
r_env *env)
 	if (tgt_prog && prog->type =3D=3D BPF_PROG_TYPE_EXT) {
 		/* to make freplace equivalent to their targets, they need to
 		 * inherit env->ops and expected_attach_type for the rest of the
-		 * verification
+		 * verification; we also need to propagate the prog offload data
+		 * for resolving kfuncs.
 		 */
 		env->ops =3D bpf_verifier_ops[tgt_prog->type];
 		prog->expected_attach_type =3D tgt_prog->expected_attach_type;
+
+		if (bpf_prog_is_dev_bound(tgt_prog->aux)) {
+			if (bpf_prog_is_offloaded(tgt_prog->aux))
+				return -EINVAL;
+
+			prog->aux->dev_bound =3D true;
+			ret =3D __bpf_prog_offload_init(prog,
+						      tgt_prog->aux->offload->netdev);
+			if (ret)
+				return ret;
+		}
 	}
=20
 	/* store info about the attachment target that will be used later */

