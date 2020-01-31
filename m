Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD2614F36B
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 21:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgAaUwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 15:52:54 -0500
Received: from mail-pf1-f181.google.com ([209.85.210.181]:33977 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgAaUwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 15:52:54 -0500
Received: by mail-pf1-f181.google.com with SMTP id i6so3961434pfc.1;
        Fri, 31 Jan 2020 12:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WcImXaVJ5xFLxdQlO5pxg/sgsWml7hPwoVGgOSXa54E=;
        b=WDQnFvZDfy2/68PjMYjoj5CQ99WMGu/FrNceTwCeg+RnM/ZZXdJcFJ/etzCH3G+K9r
         tPy59x+RjefU1Xu85AMTeLTPXPjUEkX6v033jKVmD1FZLBCpbe0jbCvUB/mLMbTZib7u
         LwEPwJjiGgJ6YaepZWKhvqx0uzJCXo2u6Nta575PYBje/7MeYHwfrtIxxx4QmkiYHIqG
         5cI7IXnFqRdKYxmrb4CiUF2eHGpqv9wTILHRvCWTk7706mOrE2qWQTN0XHR2dcXYo5OA
         jytmExABYZWnRAocmOw5eGQuvfJo8nyX5p4Hke+SqUu1YDWHlXlFi6vAClcI40fV1fqV
         fuaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WcImXaVJ5xFLxdQlO5pxg/sgsWml7hPwoVGgOSXa54E=;
        b=X20oT0vvAShmJlofTbdnJXOe7/A2BNX8MU9GJrvqy4HXYlCEGxw/bCbNoFlt5aVGh9
         K36bfHdzGIv6o9ldJ7YsUnJeTTgvUTt8ddmPgKrSFRHvbeb37gCgp9I5kVOSYqOxj4KV
         tqwASt5A3aOewaYIQxsJOnz/bOy56UvaCayvDOOZBMa4yCpJk3qj+grXqWOindTuVTEL
         VnMDBqqoN31gJOqz6K2n9JL/KhmVbn0Pi8mCTJ1ZGxjaBlkNAU/BBOuOIvgcQDIKOfOx
         /oNsQxUc6YVvw4p5aGMrSB7NBw3KNQQJbrcejwQLAlq9X/GkKuDwaUtHu1LeAwyJ3elB
         FTJA==
X-Gm-Message-State: APjAAAVyswzW5XoFBDc6V+sIX3vjtcYYmcH2DlmhFKJtxsUC3q8etBZs
        i4wOyPnvGiztdeujMVCZfvYEb5kBvew=
X-Google-Smtp-Source: APXvYqxHUey9/YOsqpgaM3L4MdLEhz3u9ODuF/3lT9Ia7gsboTJ175OSI/76JbuQLF3j2NIcMiD3cQ==
X-Received: by 2002:a05:6a00:45:: with SMTP id i5mr12189501pfk.252.1580503973481;
        Fri, 31 Jan 2020 12:52:53 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id m128sm11599169pfm.183.2020.01.31.12.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 12:52:53 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch nf 0/3] netfilter: xt_hashlimit: a few improvements
Date:   Fri, 31 Jan 2020 12:52:13 -0800
Message-Id: <20200131205216.22213-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset improves vmalloc allocation handling and
hashlimit_mutex usage for xt_hashlimit.

---

Cong Wang (3):
  xt_hashlimit: avoid OOM for user-controlled vmalloc
  xt_hashlimit: reduce hashlimit_mutex scope for htable_put()
  xt_hashlimit: limit the max size of hashtable

 net/netfilter/xt_hashlimit.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

-- 
2.21.1

