Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27552BB1EA
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgKTSCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728438AbgKTSCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 13:02:00 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45A9C0613CF;
        Fri, 20 Nov 2020 10:01:59 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id y17so14044091ejh.11;
        Fri, 20 Nov 2020 10:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZHlPDc9Juyz9GO1VkrQBp9QuPjGIDPQ8AofEX/x8Cbo=;
        b=pfZsxNWBLDC2OuhMxDpD7tpabZcdanHEgvnLCF43ZE6dh4fIq+x6OGl3SqCkivi5X4
         kR2sy6XXhA1geH5kNq6X1l5El+YwY0ASFAQVTe3rQT74DOxBjFJOtHiWujhEhYrXSbJs
         cJ+WJreH8JfTb2Q/aehF/UUzLcxjuqkLQ4aCwtlWDOveYCtIkAvNB+qkWJUb3vUZXgd9
         dIbMXpP2XmRzoclTN5WAG7xK0aILXIaMWcQ/ndQPOQbJivC1YI8nAAsg3ZcSun9bVQs4
         5FSikJGMnYMo2Cy/Ft7unZUETmSyUJL2B+Ew6iUYww/OBEplu0WsxKrb93VWdeiK4NLT
         DL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZHlPDc9Juyz9GO1VkrQBp9QuPjGIDPQ8AofEX/x8Cbo=;
        b=BQeKovkwxjDtZaIgOsnFkH3+26jRurrMnaYkhMmWXMKFSNeAwFp9pLSXYChEj0hzzr
         rmgyzkQExS8G+jYcnv0o72koqFL0Z1LDhlNvhT+M+W0JL6dDfZXCoYKYZrWXDabJRH+x
         7fXM3WKf2+btmUIWWE5yeVoNqW+2APUo57rgUXfMnNAERRvrwd5D4AqMxFWyD2iJRNRE
         ldtA8LUHm7OFCJQnCg9Bop+d7BMmv5WRMRFDrxtHqZk/EesP8zjZ1KrAPp1WaDjIvMCE
         lJbnmk2JVXodUHoN0jFyPwwNJpF3W5IaPu/FuIV8AzlaTJIxNYi3fffRulS62H/zm++G
         FaYA==
X-Gm-Message-State: AOAM530Mj3474eOkpuETO446LqTd60uAikMGlOMDGide2h8MyibY8PRx
        zDGVd59egAYBy+EHr8GZhcE=
X-Google-Smtp-Source: ABdhPJzcLHScrILGBpSkLukYGwUpHOE+eU+4Ysaad5rEwj5QtGKsFtJQuoCQ2eZ/UigaTGBq6vM37w==
X-Received: by 2002:a17:907:2657:: with SMTP id ar23mr16286661ejc.386.1605895318334;
        Fri, 20 Nov 2020 10:01:58 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id 27sm860119ejy.19.2020.11.20.10.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 10:01:54 -0800 (PST)
Date:   Fri, 20 Nov 2020 20:01:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: dsa: avoid potential use-after-free
 error
Message-ID: <20201120180149.wp4ehikbc2ngvwtf@skbuf>
References: <20201119110906.25558-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119110906.25558-1-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 12:09:06PM +0100, Christian Eggers wrote:
> If dsa_switch_ops::port_txtstamp() returns false, clone will be freed
> immediately. Shouldn't store a pointer to freed memory.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Fixes: 146d442c2357 ("net: dsa: Keep a pointer to the skb clone for TX timestamping")
> ---

IMO this is one of the cases to which the following from
Documentation/process/stable-kernel-rules.rst does not apply:

 - It must fix a real bug that bothers people (not a, "This could be a
   problem..." type thing).

Therefore, specifying "net-next" as the target tree here as opposed to
"net" is the correct choice.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
