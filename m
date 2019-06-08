Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60B6C3A05F
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 17:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfFHPVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 11:21:38 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36224 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbfFHPVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 11:21:38 -0400
Received: by mail-pg1-f196.google.com with SMTP id a3so2710977pgb.3
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 08:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=ScVZymX7ndOjwcri0zP4Xbay4iL63c5qZIrLrzRODzw=;
        b=nldIskdMsvoIbKgCS0oHSjPvVBeT3w0G55Ru4bsrC4KKwp1MG9PhH3KP6hyh7bp8lg
         RMaFzRvAdPCFdEI7xy5OuFhqSi0KMLebWGuBklgXatgA0qcMZWEUtjBt7GC3nO9PILiO
         TdvWi95c4kBZqHDFXlIvwK72POb35dkzcgwaDtsnYVAA+Gejlhi0KflOu6u90lQwrUO9
         pOAHdNuHkjscoUNFCNRebDjdL/KcywFs6oYQ3kxV4oad1Jps9aCTe3huIzgYbCPk7RMV
         yZEOnYtFTyBxRGkqyrZXZOpN9cjnYWpNdT8kQF65GtpQYHL75V4PA8sCJGtnYG6I4h4W
         bLIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=ScVZymX7ndOjwcri0zP4Xbay4iL63c5qZIrLrzRODzw=;
        b=l8zR96rR4MeGOLRzuZQ3m47lk2yXaGTm45FMPSbj1QUWoHEZiXP1FsScXyZ71JNncr
         0XESwtyVJJjS+ha9oSymNj75kSXx5VCmYxeiF9Iv3aIoX3GVONmSceSLyBeXBR0wi3Fq
         nfWO5lJ1BmlZNwxK7e2hLeexzMgAarepXr6va1WxeGoAWMuyiGkJjDQCers6/QSvPw7k
         hdOQpVBgn5LUAL74z7/WRUdBBSfn+DGnfUPlafcYqQd5IJVRIcj13uMIdROcUuR2tmQ7
         2Yfkhq198/Zd9fa3o01r7xgduVfNt4KuGEBOTDw2oEc38jCkoS6EP0xf1PmQeQFveHHp
         M8nw==
X-Gm-Message-State: APjAAAV3nAd+E16wKEXMA/d+MZnzXT5/NC9Py63Jxrdv0jYKwpc6njiV
        cmjqNNI2MG2Rs/C0C1jSTDQ=
X-Google-Smtp-Source: APXvYqx+YCTg2/l+ux11RsR9bhQemCubSMYtPlc8RaVLYPTpFp5n7ChEHtoCQL3t46py8oLwq48wEA==
X-Received: by 2002:a17:90a:9bc5:: with SMTP id b5mr4336067pjw.109.1560007297787;
        Sat, 08 Jun 2019 08:21:37 -0700 (PDT)
Received: from [172.20.176.13] ([2620:10d:c090:180::1:b05c])
        by smtp.gmail.com with ESMTPSA id 18sm1465025pfy.0.2019.06.08.08.21.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 08:21:37 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     yhs@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     kernel-team@fb.com, netdev@vger.kernel.org
Subject: Re: [PATCH bpf] bpf: lpm_trie: check left child of root for NULL
Date:   Sat, 08 Jun 2019 08:21:35 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <F0ADF03F-A512-4E44-A1C7-A3877B255FE3@gmail.com>
In-Reply-To: <20190608024428.2379850-1-jonathan.lemon@gmail.com>
References: <20190608024428.2379850-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7 Jun 2019, at 19:44, Jonathan Lemon wrote:

> If the root of the tree has does not have any elements on the left
> branch, then trie_get_next_key (and bpftool map dump) will not look
> at the rightmost branch.  This leads to the traversal missing elements.

I just realized this doesn't handle all cases.  Will reroll a new version.
-- 
Jonathan  (sigh, #fridaynightfollies)
