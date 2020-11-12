Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77162B12CB
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgKLX2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgKLX2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 18:28:33 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B91C0613D1;
        Thu, 12 Nov 2020 15:28:32 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id c80so8415522oib.2;
        Thu, 12 Nov 2020 15:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=qBz2ikggoRTZ09dTAsMMFGrnP2NqKHVAFQzLy/TNIXU=;
        b=Pdu8S3htyjph3nhGOk0m9xm3NzC2JE5f3wej72C4Ry82ixnDkb2TQrsKN2xnFhiPt7
         oVTXU9rE0OoNlWnhaGNesrQyXqQuGoejhV+MDTQo8EnmRq/g0kiKjdKkGFUcB4j6Z3d0
         MTTy3NeqQUeQph995kcxoD0MBhPt/yKRd0LQu6AIltKZkMi3lSG2qGlMewif2W1Ookcn
         ahhwxUOgUsjQ7vI7uwfRQ0ERyxj0F6gpAJXRY3G7U/vKQkvTgtPI88gz9NOmdViBsbDG
         12Iv5rUHerYsY3N4qtG0J7CmyFIsWAVMX55FrFzcFUfWTSpNPt6LKUqHkqhJhsJcFYO2
         wD6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=qBz2ikggoRTZ09dTAsMMFGrnP2NqKHVAFQzLy/TNIXU=;
        b=e2n47fjRcd0iTIVbY7eZo9L9OJA1gi3pvMQ9SUiMlCdrQlgJRLyxT3MAEaZTH2YSmj
         b5P3UmJyeEcqSbKpgVmBywS6Ek5V3FUrxWnQNTT2CdaDbQKMR3hm61lbYH6fUX7pQkPT
         +LD710g1ojKy8onmcV17V8745tDLitVtM+SnCc42IcQibxhoNjsDtPexANQHEZkcMdD3
         uSVFewvRt5XF/nnUirIHtcd/DSywQRuyDz0EiiWPevX5iXSr2WgE1sZC6NsWHNDj2tVo
         9SQvYNm12/3W4PbOKjdG2Wym20UHG61n+EZ2hdh2ZB8raJMgVeQWSU+yGUHettKy4mkW
         HYtA==
X-Gm-Message-State: AOAM5329Y9POTqXitlnjE47qcOYXlpqC607D+EE2phVuKU+q7e2hDkc/
        /rFoPeXt3V4EqVJpOPhB+DU=
X-Google-Smtp-Source: ABdhPJwKlPGMniLJTTbqbt1xiRns3tUVmKw1gZF1Lg3LOg/eBVSjdZW8sFD9aiHHj2HdL+BxfVgD1w==
X-Received: by 2002:aca:da89:: with SMTP id r131mr176976oig.166.1605223712412;
        Thu, 12 Nov 2020 15:28:32 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x83sm1468346oig.39.2020.11.12.15.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 15:28:31 -0800 (PST)
Subject: [bpf PATCH v2 6/6] bpf,
 sockmap: Avoid failures from skb_to_sgvec when skb has frag_list
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, jakub@cloudflare.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Thu, 12 Nov 2020 15:28:18 -0800
Message-ID: <160522369822.135009.15718253545046438408.stgit@john-XPS-13-9370>
In-Reply-To: <160522352433.135009.15329422887113794062.stgit@john-XPS-13-9370>
References: <160522352433.135009.15329422887113794062.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-36-gc01b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When skb has a frag_list its possible for skb_to_sgvec() to fail. This
happens when the scatterlist has fewer elements to store pages than would
be needed for the initial skb plus any of its frags.

This case appears rare, but is possible when running an RX parser/verdict
programs exposed to the internet. Currently, when this happens we throw
an error, break the pipe, and kfree the msg. This effectively breaks the
application or forces it to do a retry.

Lets catch this case and handle it by doing an skb_linearize() on any
skb we receive with frags. At this point skb_to_sgvec should not fail
because the failing conditions would require frags to be in place.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index f747ee341fe8..7ec1fdc083e4 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -425,9 +425,16 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
 					struct sock *sk,
 					struct sk_msg *msg)
 {
-	int num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
-	int copied;
+	int num_sge, copied;
 
+	/* skb linearize may fail with ENOMEM, but lets simply try again
+	 * later if this happens. Under memory pressure we don't want to
+	 * drop the skb. We need to linearize the skb so that the mapping
+	 * in skb_to_sgvec can not error.
+	 */
+	if (skb_linearize(skb))
+		return -EAGAIN;
+	num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
 	if (unlikely(num_sge < 0)) {
 		kfree(msg);
 		return num_sge;


