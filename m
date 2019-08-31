Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD8EA450F
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 17:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbfHaPh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 11:37:56 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:40921 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbfHaPh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 11:37:56 -0400
Received: by mail-pl1-f180.google.com with SMTP id h3so4692123pls.7
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 08:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3fDsNXmuloVaoguh8dR/kFjzVXN30yRINYg7z2nLNgU=;
        b=IhhvOijO9KFBWhm8Ob+1eGjfYHLTM/hUmgXkFGc2k/Cdul5ODTozTJPHqSQbATM+Jb
         RFHR5GKNxWmm1PM8iE+ZsKlHCjnXMi51Od42mnfsTe5WzR6RpbqMYthsVUlFjwVcx0Fc
         IXpwiv/HutWZnQRE93oqgFScQyAfCQPMQCtdDSleEJg9B4C2Rj+rIC0M79pq8bSOODP6
         qwvLNj6snSP9iHhHa+1os8k6wxmLUvdcBlmdebKA6+21uIlHjhuyWuC8bSPrR65OjD9F
         uM3aDqKixM4P8/Hzsdv06zLC+BoTyee9VtK2yNSOmcREqVZG8uiJYPXqNjnkb5VXjPbn
         tNaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3fDsNXmuloVaoguh8dR/kFjzVXN30yRINYg7z2nLNgU=;
        b=So9/cEt4UUxjUKeAc/Ag8Ptdw19O5zHi8QGE1lycLpFRGUxNpuv8wcUq+k3mugEpc6
         BGAqM1hTOKZEMWeyiNi6oXWQENtlCFOnnopk6xQM0lizJwxHr61Wss07Qw0qTDRm62Yb
         6sRP+A7VFEX2W4Jzbd+kPT5NJFg89fjRziA23ccWAYEdMjvk4UZvYYfhIMVlYubbbjXn
         32lbXarVf6DebNZVFy6Rz3RnvpgO5rT4omaGq0E1hx8Q/GvDgAcAfXLUr6VieLwomf2p
         +5w23k6/Zs+/injtTLw4/s2Leu15b77jINMhToA3blS05RTUlQXbTukTlxj4J+MUlp/h
         EIoA==
X-Gm-Message-State: APjAAAUmxi2FuNkS6dLM1wZ9KPbrDnj2NiZR6z3PCc9Tu12/8zUT57rm
        d1BoGzmFjpDY4vfpLoKo8NJRTiOR3aA=
X-Google-Smtp-Source: APXvYqz1EkAu1+eubAOzYYTSrUfDPk3qr9YD3S7QDzhfwY6lWfbXrDkYhYX9J4ctvEjpyqba5X8JEw==
X-Received: by 2002:a17:902:1024:: with SMTP id b33mr21952936pla.325.1567265875716;
        Sat, 31 Aug 2019 08:37:55 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id ay7sm8042603pjb.4.2019.08.31.08.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 08:37:55 -0700 (PDT)
Date:   Sat, 31 Aug 2019 08:37:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     <tomaspaukrt@email.cz>
Cc:     <netdev@vger.kernel.org>
Subject: Re: iproute2: tc: potential buffer overflow
Message-ID: <20190831083751.3814ee37@hermes.lan>
In-Reply-To: <8fo.ZWfD.3kvedbSyU2M.1TQd9t@seznam.cz>
References: <8fo.ZWfD.3kvedbSyU2M.1TQd9t@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Aug 2019 15:13:27 +0200 (CEST)
<tomaspaukrt@email.cz> wrote:

> Hi,
> 
> there are two potentially dangerous calls of strcpy function in the program "tc". In the attachment is a patch that fixes this issue.
> 
> Tomas

This looks correct.

Please fix with strlcpy() instead; that is clearer.
Plus you can use XT_EXTENSION_MAX_NAMELEN here (optional).
