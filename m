Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C390C218318
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 11:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgGHJE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 05:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgGHJE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 05:04:58 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F48C08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 02:04:58 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dr13so49551536ejc.3
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 02:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=ZnVTT8e8E5uE5W1IEqG8v7xljDoffbPIC4fgn+PQcWg=;
        b=GpDfdGn4ZY1oscicGSuS0egnhCrJ9y3j0R+zKdvM0XswCvyWq0yoYlSWk+qLdMTlaH
         7HhroEet2sHgCzt6CgzeEPMB6i4BaqZGfhsf48LxDPOyEO6H73+nGXW2B5gzVMZxylBO
         P5bROVUkDI8UspfXCQaJ4Lf8Ah8fD1pOrEPscnRS0J80yRnxKuykOqBw/DE91C6VyG+F
         hOP7RHxtkLda3sXxSojFRvdpzMgqo9DXG4Ecgk8pwXQSRi5NRfhUjiTYvF6xinS8RwbZ
         TRlG7fQl82ba3sJsyr+4xN8+sGJ6skSZHvnRrLLwBcNWcLzg3XS+8irlEmWTLj/FWM3O
         VeDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=ZnVTT8e8E5uE5W1IEqG8v7xljDoffbPIC4fgn+PQcWg=;
        b=Xd+pIHNCTORgNS+9lW5nC4qekTmIUWELMcJz98nXwncGx8lh9ILvQH09iquywgwI5H
         dry0GgBnsKJvGhFXx/9uri2d3JVizMziv02y3StbK40da7cb1z+qab19pZr8ryc/HKmY
         i+SjtHZaNfDgRMtbWV+BGeXLhf+MRPFCtm0oCR2XuNnfvLx3zjL4ZaBtWUypNvplRrRU
         jeUZn/65xyj2joiijRZHqVsn6Pmf2LurkyAa2xhFj7EM3Y3bsugUm8zSUv54V40L2Eom
         2DpCZYIkGHkwpN7pKUMiAhSp+BEfUoRU/+XlOF/mToyMXAGPPq3ZMZZJJOPIMN9abMMf
         6g5A==
X-Gm-Message-State: AOAM5336w1weD+sXExZBERA1lPd7I6qhfPypbVgrTPS0Jnenb9/+vc7E
        UTkiCMKxLILZ0kGnVAdPQDmgx7Nw
X-Google-Smtp-Source: ABdhPJwcpUeKqZJFe0cfS2bTyxx1AA4L2WNCs3uLQd5Pd0Gj1gJsA3gyHFOE48Ir0Fhr+h6albGfOw==
X-Received: by 2002:a17:906:6499:: with SMTP id e25mr50580520ejm.352.1594199096796;
        Wed, 08 Jul 2020 02:04:56 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id v5sm1654889ejj.61.2020.07.08.02.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 02:04:56 -0700 (PDT)
Date:   Wed, 8 Jul 2020 12:04:54 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org
Subject: What is the correct way to install an L2 multicast route into a
 bridge?
Message-ID: <20200708090454.zvb6o7jr2woirw3i@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am confused after reading man/man8/bridge.8. I have a bridge br0 with
4 interfaces (eth0 -> eth3), and I would like to install a rule such
that the non-IP multicast address of 09:00:70:00:00:00 is only forwarded
towards 3 of those ports, instead of being flooded.
The manual says that 'bridge mdb' is only for IP multicast, and implies
that 'bridge fdb append' (NLM_F_APPEND) is only used by vxlan. So, what
is the correct user interface for what I am trying to do?

Thank you,
-Vladimir
