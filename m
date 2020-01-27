Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1B7149DF1
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 01:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbgA0AOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 19:14:32 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37924 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727250AbgA0AOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 19:14:32 -0500
Received: by mail-pf1-f195.google.com with SMTP id x185so4076080pfc.5;
        Sun, 26 Jan 2020 16:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jwKhSkxejmyMPyM+NVjUzzmt99OqXL3Od8mcxBL1EyU=;
        b=KzIA6lKlm9r14alo9oUUhjDXA3ZfYQgq3ShYMZl3kZGwnBzvqUpk95mvY65KsQ6z8I
         qrTpJo7DgBQT475zg9jgxi3VxFJ/nzN/SpsDILQN4uKjaPuVlN9IKvUyZq+p7gE45dTA
         0xmwZHIMXcycWcf/Ex8jOU1nR23LPDy1sM9ypayxyrDAo8JxVKLMe4QeSbfd/VcEkstV
         z89DWZSwozkr9PWLn/JDbtvw7wrK9+8orMOvnnzPh8sYQwuV1fQOJ0Ys/v94tsIsij0S
         u8SHWMspiyltDcN0N3E19PE6sC80wUvHDfAsUvisGTg+D8Qs5HmUZ7wcAj9KW6rTEPiI
         IlGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jwKhSkxejmyMPyM+NVjUzzmt99OqXL3Od8mcxBL1EyU=;
        b=KCLu9D/W/RyiJ3xDIWM8BMsIuNINANlfJrTf5jOZ2ObF87s5ThLtagBZiF+YfgH0y1
         iW1AZ5tsWYfhbHEpQul2cxUWWZzNdtgZmyf86+y6q4qK3x4oMYdC8iv+54eEsXeyZhEy
         Um5dsiFTxmu95oKYowADh2Wt0SJ+kWr5PrmU7CqtlI3DR2+PIgmcR7g6GZklZcFH0PKU
         k9An5wKA3ppxJi8qklgYWPNrAH3J5Z3VDRwNCKQjmNmsqr4FdzJDalvhHTiwlOKz8dLy
         sS0KzmjHSf8kdwfMavWc05nfQuelHSeiAR1N+NNL7CVN7uCSkjDyPP+ld815zKHW83Dd
         2YbA==
X-Gm-Message-State: APjAAAUV4jAjGsdEzKHUuQ+vpNOgtRcl3aQfpVP4u0l6dRx+TLFetGFo
        fdS3uy9fD7lbYCJrdl7/i7VhCtgS
X-Google-Smtp-Source: APXvYqwUKVDer0FpGdFYXA6N3SPce7fkiWTORnJcD7OhGLqI+0LLvgzE/TObc301N6Vg1mYOfsL/mA==
X-Received: by 2002:a63:1346:: with SMTP id 6mr16735605pgt.111.1580084071242;
        Sun, 26 Jan 2020 16:14:31 -0800 (PST)
Received: from localhost.localdomain ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id i23sm13326949pfo.11.2020.01.26.16.14.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 26 Jan 2020 16:14:30 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     bjorn.topel@intel.com, songliubraving@fb.com,
        john.fastabend@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        toke@redhat.com, maciej.fijalkowski@intel.com,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 1/3] bpf: xdp, update devmap comments to reflect napi/rcu usage
Date:   Sun, 26 Jan 2020 16:14:00 -0800
Message-Id: <1580084042-11598-2-git-send-email-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580084042-11598-1-git-send-email-john.fastabend@gmail.com>
References: <1580084042-11598-1-git-send-email-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we rely on synchronize_rcu and call_rcu waiting to
exit perempt-disable regions (NAPI) lets update the comments
to reflect this.

Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 kernel/bpf/devmap.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index da9c832..707583f 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -193,10 +193,12 @@ static void dev_map_free(struct bpf_map *map)
 
 	/* At this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
 	 * so the programs (can be more than one that used this map) were
-	 * disconnected from events. Wait for outstanding critical sections in
-	 * these programs to complete. The rcu critical section only guarantees
-	 * no further reads against netdev_map. It does __not__ ensure pending
-	 * flush operations (if any) are complete.
+	 * disconnected from events. The following synchronize_rcu() guarantees
+	 * both rcu read critical sections complete and waits for
+	 * preempt-disable regions (NAPI being the relevant context here) so we
+	 * are certain there will be no further reads against the netdev_map and
+	 * all flush operations are complete. Flush operations can only be done
+	 * from NAPI context for this reason.
 	 */
 
 	spin_lock(&dev_map_lock);
@@ -498,12 +500,11 @@ static int dev_map_delete_elem(struct bpf_map *map, void *key)
 		return -EINVAL;
 
 	/* Use call_rcu() here to ensure any rcu critical sections have
-	 * completed, but this does not guarantee a flush has happened
-	 * yet. Because driver side rcu_read_lock/unlock only protects the
-	 * running XDP program. However, for pending flush operations the
-	 * dev and ctx are stored in another per cpu map. And additionally,
-	 * the driver tear down ensures all soft irqs are complete before
-	 * removing the net device in the case of dev_put equals zero.
+	 * completed as well as any flush operations because call_rcu
+	 * will wait for preempt-disable region to complete, NAPI in this
+	 * context.  And additionally, the driver tear down ensures all
+	 * soft irqs are complete before removing the net device in the
+	 * case of dev_put equals zero.
 	 */
 	old_dev = xchg(&dtab->netdev_map[k], NULL);
 	if (old_dev)
-- 
2.7.4

