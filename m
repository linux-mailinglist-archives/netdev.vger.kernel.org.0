Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8655193A8
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245490AbiEDBvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245374AbiEDBvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:51:11 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BC0326D7
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:47:34 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k14so43026pga.0
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+ZZ5vfFx25K1I7i1kYl8UxhLqvkhElnoRitD8+hKJmA=;
        b=DpRwgsc8k+bO9cXVHmU7ksT2E8T7R4om62xOunRq9j6F4/Hlmd+72tPALfSIkWpTBv
         6ZsB/FoXumwXqUlvu94h7ehF0Poi6zQZRyL/SVAXWNru3D7CYZKN+GO4S+p3OYu8TvOf
         p5r4/HuAd0PoSIWCdxVFPC7ODUIYPeBjfKvmU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+ZZ5vfFx25K1I7i1kYl8UxhLqvkhElnoRitD8+hKJmA=;
        b=oXQ7Ro54AYVC5UBCT77eA8xdPjekXNVFG7EVerfl7MR33DQ82sYTKASHypUXqqdNfn
         juRPIRdmJBZ8OpW41DZYpeiTCFpvWuZXhJBS53lcW1biaswl4t6IRTVerfhnSs8v42Eo
         wX+v8FJSkBnxL3N0DYPCzzEalZdLQ/3YGRFRWFyRXgBjwdNwnGlSY9RLIhLrIomkL5F0
         06yFczH/oFWIU+L+DlZ1yykZSFjB005xvzbqS3BZzw8AU82XZg+/39LNKWnIiBDfY64W
         2q0DVl1NnmRTLGo3mBd7svRGbgIMSpXfnrMS2mfn+7oBa9TQU//I5thlf1Gbx1P6OTua
         ErqQ==
X-Gm-Message-State: AOAM531bHQjW95CZO9rl81IiXjlQDCOKIg1/z0TipVeaVGpkyWOflKiq
        +nRj4BTDhAttkS0AwqM3fI7EhQ==
X-Google-Smtp-Source: ABdhPJx1pk1Kj8VquWNvjueoOJF84IDUN+sdPy6JRVklo0yvv2jKaWOAa1dEeUA85vrZ210XI6GffA==
X-Received: by 2002:aa7:962e:0:b0:50d:5ed8:aa23 with SMTP id r14-20020aa7962e000000b0050d5ed8aa23mr18603820pfg.43.1651628853848;
        Tue, 03 May 2022 18:47:33 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k8-20020a170902ce0800b0015e8d4eb283sm7000015plg.205.2022.05.03.18.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:47:33 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rich Felker <dalias@aerifal.cx>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        alsa-devel@alsa-project.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lavr <andy.lavr@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Christian Brauner <brauner@kernel.org>,
        =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Chris Zankel <chris@zankel.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Axtens <dja@axtens.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        David Gow <davidgow@google.com>,
        David Howells <dhowells@redhat.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Eric Paris <eparis@parisplace.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Felipe Balbi <balbi@kernel.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hulk Robot <hulkci@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        John Keeping <john@metanate.com>,
        Juergen Gross <jgross@suse.com>, Kalle Valo <kvalo@kernel.org>,
        Keith Packard <keithp@keithp.com>, keyrings@vger.kernel.org,
        kunit-dev@googlegroups.com,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Leon Romanovsky <leon@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux1394-devel@lists.sourceforge.net,
        linux-afs@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, llvm@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, selinux@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        SHA-cyfmac-dev-list@infineon.com,
        Simon Horman <simon.horman@corigine.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        wcn36xx@lists.infradead.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 01/32] netlink: Avoid memcpy() across flexible array boundary
Date:   Tue,  3 May 2022 18:44:10 -0700
Message-Id: <20220504014440.3697851-2-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2198; h=from:subject; bh=m3+rrHA3rlt0sA4WgKzRJNTXeSTN4vWW0f0prUvbWYY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqAKYSI60YG7oB43Zm2qf2XEYFq9+0dv6JxgKQA Vag6ObOJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHagAAKCRCJcvTf3G3AJt+PD/ 4wYVpcKl2liC+Uc4jUmmdOovQey8J6/k2HmeHGxkjjuXUGIWCxvRqFTmpp0zt8q6NeCY1dzyQE7A9N PW2CVLlv5GLZfLyBlcsOWL4hofk/Ed905HvAky/Dx8yVe0LszOaIIrWGUii70nX0RIZBcDlNYaOY4k wGJaGLJ9XI5Abp/vMi8qzgEIVt5Qty6Z+cfnpAvETE9FFC0ibHAuxSsOCPhKMgvWgkyDjMAVgJQC6t TKGjSE1Rwow+68x8cxXa3ZsNgWXO0wHDaWWB4/QUxyVrq/AqCxOvgu3SljXBgVpaeUF41w+gB7rTXz Jpn7XXtJZLIDQT9yoNDAsj8yjQSIPdaKabA732knKP+dXXvoimMLj17LWxunuIrNQJ5Awl5Dz2jNa4 96eQ4Eabc5miPNc5+9VOK1Wc20FUE/uqW/VkQkBWzcnLXslpLRuJ2jNTFzk50BKZOJ20vutotuSmWf 5gqjyHzRfK+iajoBCEV6nUiWN7ewO8XDDayLZtzu5foCWXgFFwp2ZWksNnvY6M1djooGD0fU2cMDkZ HK9WR0ZfO5zv8cE5RCjDXb25deVhtGS6HRKU3vBlDmFx3drFqOEK/4zwTej6ttVyJqAspxBqEq7xpi JDgQOkTfh60YdtsNYhykruXCL3NnFuRLtxOeMGWD4IL6YtPwYfH3V6aFCljQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for run-time memcpy() bounds checking, split the nlmsg
copying for error messages (which crosses a previous unspecified flexible
array boundary) in half. Avoids the future run-time warning:

memcpy: detected field-spanning write (size 32) of single field "&errmsg->msg" (size 16)

Creates an explicit flexible array at the end of nlmsghdr for the payload,
named "nlmsg_payload". There is no impact on UAPI; the sizeof(struct
nlmsghdr) does not change, but now the compiler can better reason about
where things are being copied.

Fixed-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Link: https://lore.kernel.org/lkml/d7251d92-150b-5346-6237-52afc154bb00@rasmusvillemoes.dk
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Rich Felker <dalias@aerifal.cx>
Cc: Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/uapi/linux/netlink.h | 1 +
 net/netlink/af_netlink.c     | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 855dffb4c1c3..47f9342d51bc 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -47,6 +47,7 @@ struct nlmsghdr {
 	__u16		nlmsg_flags;	/* Additional flags */
 	__u32		nlmsg_seq;	/* Sequence number */
 	__u32		nlmsg_pid;	/* Sending process port ID */
+	__u8		nlmsg_payload[];/* Contents of message */
 };
 
 /* Flags values */
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 1b5a9c2e1c29..09346aee1022 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2445,7 +2445,10 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 			  NLMSG_ERROR, payload, flags);
 	errmsg = nlmsg_data(rep);
 	errmsg->error = err;
-	memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg) ? nlh->nlmsg_len : sizeof(*nlh));
+	errmsg->msg = *nlh;
+	if (payload > sizeof(*errmsg))
+		memcpy(errmsg->msg.nlmsg_payload, nlh->nlmsg_payload,
+		       nlh->nlmsg_len - sizeof(*nlh));
 
 	if (nlk_has_extack && extack) {
 		if (extack->_msg) {
-- 
2.32.0

