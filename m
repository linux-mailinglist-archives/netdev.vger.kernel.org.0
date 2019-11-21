Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF0E105CAB
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 23:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfKUWZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 17:25:58 -0500
Received: from mail-lf1-f44.google.com ([209.85.167.44]:35238 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfKUWZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 17:25:58 -0500
Received: by mail-lf1-f44.google.com with SMTP id r15so989815lff.2
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 14:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Y+akNCY/eeQn75CBMwoisF2n7Y1Turdl5YP/YwgDHRc=;
        b=j7DhVODt5xtvI+8yq0EsKR4PA0kcGfYZz9DqkVsyeXH+w57dejwWlHccA4i7shaoYN
         wOeGwTp9WgE6RmxQEI7rjaWPmJqzxLwQZmTB1iyrzBRjsOHWcJva3QYuVztUD5hN8lKV
         0z0qb9oNQckw5Uz8YBoQG0dJN2R6TowUpwW6a1y/BWPJADrA26Oa20yJtmmI4CgBXou0
         aEnJqlh8yuQ32vGSNEP0LJJkmeQKVZZHxN+GtV50dGJyPq5QPDdM6DyvZBuoaC236w0D
         rm9+Ej5VyU5Vq0FNprCOc9ru6Kki4nZe9is/0B9dhumogpGgqRfT1m+z04F5dD+1NjWr
         g6xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Y+akNCY/eeQn75CBMwoisF2n7Y1Turdl5YP/YwgDHRc=;
        b=etkNY0apLrPWioIU9pFSgyxkwWdCJCgZlX/g03P3GSuTp/njs0imkhCtBYKBPIvu8r
         vr+Hd7n8rsxE8ouBeyNxrjeh3gRXYkMz75f3rnnBH9tQa3ijywspwpWSYJ0EsJ2V2qxC
         xRmaOGLVMVvTdcbTv2nFSwDaf+yc4h0+lPB9Pz7UmLCaJQRAKGbd2M9/MI799LF6sPuS
         KhcM9Xwm7PoZSy6o3u+2Qxsv4Jq7LfColcWq2ff/ldBUT0stmt95BcSitvKENBhbuLsC
         aMb78FgihRORvJSxzjf1KucFvCH6tx8qOfXZbmE78+cxREeNhGoXJr4VLIcseNGJVNf7
         EePA==
X-Gm-Message-State: APjAAAUGLlG+8KhTLxVzQ2Cxx/0yglsI8iUmmzhwQeoxilvXg2DPLI3u
        gnt1J7Fsej5iSTS+XlWyRtR7Yw==
X-Google-Smtp-Source: APXvYqx6mJBXIbvh/yNvxgrbJIcNYSCy3jDg0sBZGMFvyT34hUp7s6AfPWd3FU0FDxOmYr60c8cW+g==
X-Received: by 2002:ac2:5144:: with SMTP id q4mr9922735lfd.36.1574375156026;
        Thu, 21 Nov 2019 14:25:56 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d28sm2088401lfn.33.2019.11.21.14.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 14:25:55 -0800 (PST)
Date:   Thu, 21 Nov 2019 14:25:48 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 05/15] ice: fix stack leakage
Message-ID: <20191121142548.4bb62c55@cakuba.netronome.com>
In-Reply-To: <20191121074612.3055661-6-jeffrey.t.kirsher@intel.com>
References: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
        <20191121074612.3055661-6-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 23:46:02 -0800, Jeff Kirsher wrote:
> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 
> In the case of an invalid virtchannel request the driver
> would return uninitialized data to the VF from the PF stack
> which is a bug.  Fix by initializing the stack variable
> earlier in the function before any return paths can be taken.

I'd argue users may not want hypervisor stack to get leaked into the
VMs, and therefore this should really have a fixes tag...
