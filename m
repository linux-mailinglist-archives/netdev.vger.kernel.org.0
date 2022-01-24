Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D56849A068
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 00:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351484AbiAXXGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 18:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354743AbiAXWzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 17:55:55 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67625C0680B8
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 13:10:03 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id b14so52653643lff.3
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 13:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=XIhm9fRBoZ0Uvf1w5yNzTt29w2f4X9GR2SUAtRNPHxk=;
        b=P+NNwfoFzMzEbL0OKePrZ3uTFz3u3nyl7xeggzj1fT7UlFtjwnCdPDFluAh9vf39Am
         hHWIDyJcQu9qx0jhvdzsxK/Sh71NYAYBmD53+yqUfYOBeBaiLhNQUs5bdcEn7xWfvOcz
         5fZhO+U/JXwLaptpx2UCZGJYjszzrkID+m+TgjAHgCN7iSlpVranzLzx9+/gYK8YsLzC
         EJvbIjred+HsMX4tTKxkRCRwvyx0rid7wyA3Huz2H9x7VmJnMvCF2h1Mbt54EKW9K8aI
         sZ70HnlYagJ14TNY7E5soOGLThIUeh1my/xgadZ8WyaziNN1sNfzwFVTgzn5SVVO4mbs
         hHTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=XIhm9fRBoZ0Uvf1w5yNzTt29w2f4X9GR2SUAtRNPHxk=;
        b=H1R2dMRycUWeDFZ9Qey+k8LSR6bccyNMOcS5e+BBYjF9YKNRUtw8sIljPLfi+H1Q6/
         XVE5SFVFar6F5Hu5VHYgx0JdxG7+vShCAx6gDKMl8ePxNGD7HT9JvdxmRdCK/P35WT8r
         rKtwpwHpfbsft/PyaQ1yR2MQZD50EryUNtjlE1kMs+QsJDXvjAWZPk0uotfqmSkMF5ej
         y3m6TUWOrno0JYcOMfvd9dMTJt6N9KaqcHAf+fBJ3ids0rddDg1lfonTCOwJh5TYAahB
         74R2/lJweqDXE1x2y3ymvmm5d9cXKPcyQ0Fe+8QG97F94JdzYbzyjz9SnXLNgDut2zuZ
         0dHQ==
X-Gm-Message-State: AOAM532ggBPZupwLFHMkMZukJ2bWdiFe6J+IszMwXXWnyOo8OFmWkv7W
        jZPa4UYMHoi41JOOyL8ae3KpQj8tIqXbtA==
X-Google-Smtp-Source: ABdhPJxi16epsJTS6dJ0GUMFRvUcrHLT2+A6Xil3cCZgYStr7A4YgUEqWsTMfY9isygjkKrWl8CP4A==
X-Received: by 2002:a05:6512:2313:: with SMTP id o19mr14104954lfu.623.1643058601710;
        Mon, 24 Jan 2022 13:10:01 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id t12sm1009115ljj.118.2022.01.24.13.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 13:10:01 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 0/2] net: dsa: Avoid cross-chip syncing of VLAN filtering
Date:   Mon, 24 Jan 2022 22:09:42 +0100
Message-Id: <20220124210944.3749235-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bug has been latent in the source for quite some time, I suspect
due to the homogeneity of both typical configurations and hardware.

On singlechip systems, this would never be triggered. The only reason
I saw it on my multichip system was because not all chips had the same
number of ports, which means that the misdemeanor alien call turned
into a felony array-out-of-bounds access.

Tobias Waldekranz (2):
  net: dsa: Move VLAN filtering syncing out of dsa_switch_bridge_leave
  net: dsa: Avoid cross-chip syncing of VLAN filtering

 net/dsa/switch.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

-- 
2.25.1

