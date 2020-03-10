Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6361B17EEE4
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgCJC5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:57:41 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:36893 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgCJC5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 22:57:40 -0400
Received: by mail-pj1-f65.google.com with SMTP id ca13so800309pjb.2;
        Mon, 09 Mar 2020 19:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2M6O5OzI+IU6v1/jeWA3Iv6zMngQ6Hoh4arHeMtChQg=;
        b=bjzmyPcG1cW+j8xHUhHoI/M2wBgQIKJz8qFuFz7kW/QIfEM83liwFjsus37E3VcopA
         bRGsFrCUQRCao2KdQI7jgWYfRjtNI75EyFRl2zkk0bGZcMcABZnux3C8LFpUHNQvn8+G
         qapx3IbWlz5Woo8+6gyMrKiYoi4CtdvK5mO4VxG5e16me0vCa7c1sRsy/MAE+HIzmYwj
         2Z6xPpLgI9UjUNqkLvO29vt0AMJMtYO15H1lwBi74OgBQsTQ23265+NiMtaVODP5JTM7
         Ov5JggDIK7ZnOnT/7W3xeevCclwvc+d3qLEIrP2nTQaC4UUbt2KUY9ghXjqaW+CCsfmo
         uBMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2M6O5OzI+IU6v1/jeWA3Iv6zMngQ6Hoh4arHeMtChQg=;
        b=R4qznNQ6jcm3upOzbQ/BmjaeIgfg6XGuOv1cFV0nnc43XBioOznGvLX5QyLQ1MDgE2
         8iRbI62GqOkoTQ6Gg717MT+GyCnLbzVONpnx9N0BpVdalh1clxL76Si/vhgn757JeAAd
         B0KsMB/zWCoZIBgZCc9ALr8nLX+nlXa+jJTEmBz+B9Q7r44DwYomg9L1jImy6vO2I5XO
         zIafujDs+cn9Rb5FMnIMReJ2lXnh52EDL/TIlRSgioLLfOuvWTv1NMZJ+CaTn5fV5YdA
         grCzTgyixM4q0PkUCIvv3fQG/liADln3jQYQH7DNHLyg/ruNBVn+WehE17exG/qtqYEV
         vHzA==
X-Gm-Message-State: ANhLgQ2Z26sTnCeMsIhKrotYn/VuZw3oz8d/7e+TnCqN4DqBZAT6ngJP
        nLnkmWPv9fODGyboynid3Ms=
X-Google-Smtp-Source: ADFU+vsCSStYPD9DkpF+XOPXs3X2QtTr9kOUYFeHggNhd8RoSiKV7NW2rT5nDpIuVlf7Ohcvla1a9g==
X-Received: by 2002:a17:90a:3a8f:: with SMTP id b15mr635022pjc.178.1583809059836;
        Mon, 09 Mar 2020 19:57:39 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id r64sm826600pjb.15.2020.03.09.19.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 19:57:39 -0700 (PDT)
Date:   Mon, 9 Mar 2020 19:57:37 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrea Righi <andrea.righi@canonical.com>
Cc:     Vladis Dronov <vdronov@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ptp: free ptp clock properly
Message-ID: <20200310025737.GB1679@localhost>
References: <20200309172238.GJ267906@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309172238.GJ267906@xps-13>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 09, 2020 at 06:22:38PM +0100, Andrea Righi wrote:
> There is a bug in ptp_clock_unregister() where pps_unregister_source()
> can free up resources needed by posix_clock_unregister() to properly
> destroy a related sysfs device.

This text is inadequate.  It does not identify the problem.  What
resources?  Which related device?

> Fix this by calling pps_unregister_source() in ptp_clock_release().

This statement is redundant, as we can see that from the patch itself.
Instead of saying WHAT the patch does, please explain WHY that fixes
the issue (which, as I said, you still need to identify).

Thanks,
Richard

