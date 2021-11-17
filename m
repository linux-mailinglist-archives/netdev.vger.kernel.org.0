Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D36454F70
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240374AbhKQVkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbhKQVkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:40:14 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8152CC061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 13:37:15 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id q17so3327200plr.11
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 13:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q1Qa5WRXp0Xttkqd0M1NdwAX8725jc+8TceNG5t3BVs=;
        b=3fWtp9hq/Zfy560F1UHmsJGvu78TYfCjq9eYKIRp5AU859UfzSPWL9xYjQT95VTlo2
         Bk3QtR8NTIumRVKN0MF0FXFK7XkEIkSCOLVAGb4Y87uEgPwN42ZKpaEjdU3kVS/mK2iZ
         TAMOGx/gYR5GUc0I/XZTyfOD6FmRZR9Esfm0urfv1l84kAdXGj6jeU567YuJneCD6SHl
         sBFfqsbbyGgtmfNeZ2OUi4ziYNqi9Vo34T0GKUQ329zsPaQiv8umn4uxY9lxYmIOMcrF
         5gC2BuAe6VLL5LpoAN7eE4F12sP7HmcGN3sNZMOS7SuIqsvVmm+Wb4A3BIaRa31qS9Ck
         2Z5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q1Qa5WRXp0Xttkqd0M1NdwAX8725jc+8TceNG5t3BVs=;
        b=xAnkMU/6T/ZGObP6HSGH0Yax8inO7pkeAVnrw88sHwR2M2aFcIB12jFfoo7lSsCXBi
         nkSIwBh5kHzRE0onMd6mzFhIbUM9PCkNjNjj35k8Ucq+bDYewYVEhDrbO5L5ZutC6fTh
         1f3V+qvuxgmdJM70ZjG69HcF6dIcmqBtWMXGshH1ZWqbxDUD+1wv9mPbAOWkmw9+ufPd
         bU+ZGqkyMMwjt+joHxtBqT9r5QEhEtXmJaEydmSxm4Nn7l8lWZDoubhRVupPUrMZK+xr
         0VSilleZrsLUvPsY0YU//URNy/VNi3qVVpwVEI/E+z1QSdhswQODD698PySNVdspUzXE
         IsOg==
X-Gm-Message-State: AOAM530qSLs2JhS3gyTJfGPZEZccAbilrieDyI+n2qX6nIvwr91tuSP7
        5hreeVL1CSN4/LlUgY6qyfoywTBU7SIcDQ==
X-Google-Smtp-Source: ABdhPJxP1cOQjsoWpZfLFFe/llJTM1sVNQLEXHdHJ17C8Z03eHE/xiNAC3n/jx9+VLXcRz1lypm1vQ==
X-Received: by 2002:a17:90a:4a06:: with SMTP id e6mr3804391pjh.228.1637185035020;
        Wed, 17 Nov 2021 13:37:15 -0800 (PST)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id u11sm559634pfk.152.2021.11.17.13.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:37:14 -0800 (PST)
Date:   Wed, 17 Nov 2021 13:37:12 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Maxim Petrov <mmrmaximuzz@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH iproute2] ip/ipnexthop: fix unsigned overflow in
 parse_nh_group_type_res()
Message-ID: <20211117133712.41d415ab@hermes.local>
In-Reply-To: <91362fa6-46df-c134-63b1-cc2b0d2832ee@gmail.com>
References: <91362fa6-46df-c134-63b1-cc2b0d2832ee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 22:11:24 +0300
Maxim Petrov <mmrmaximuzz@gmail.com> wrote:

> 0UL has type 'unsigned long' which is likely to be 64bit on modern machines. At
> the same time, the '{idle,unbalanced}_timer' variables are declared as u32, so
> these variables cannot be greater than '~0UL / 100' when 'unsigned long' is 64
> bits. In such condition it is still possible to pass the check but get the
> overflow later when the timers are multiplied by 100 in 'addattr32'.
> 
> Fix the possible overflow by changing '~0UL' to 'UINT32_MAX'.
> 
> Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>


Fixes: 91676718228b ("nexthop: Add support for resilient nexthop groups")
