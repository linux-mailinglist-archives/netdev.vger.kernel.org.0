Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 149444C702
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 08:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfFTGBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 02:01:18 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:41040 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfFTGBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 02:01:18 -0400
Received: by mail-io1-f41.google.com with SMTP id w25so2423913ioc.8;
        Wed, 19 Jun 2019 23:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=MqzsYCHBzioG4bOrNkmWcUKVevjbBvwuF35diEvjshw=;
        b=NcL5l3LLLGw7PeJl+xcBFGqD4FfPr/xyhLw3NrW7XsmdZdl+P/bt80At4fPExKDJSh
         CK3+Yz1GaMoQCyGWKZXx/seQaIrSGKCOWog6tdmr70Yuqg8dUNUuJ9c3XizoFZ6+Kpae
         OHhb6FDTZy24LoiPgKxajPXB9VCHX7QRNO0tez7k+g+RF8gx+CHoP/ntT+ZQnQHW1ZFc
         ygZSA6ZZn6dRr3zB7SPMPx/Hr6gzCVsMXJjiqNnx70OzA+d/lQUWJXzUDCk60VFLsaRX
         HLE915TX2g14hQbs4lpXfz1LkQJzmZff3ggdMSuqy1El3OQMKJdbEtV8vPAuT1KbDE0r
         xgxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=MqzsYCHBzioG4bOrNkmWcUKVevjbBvwuF35diEvjshw=;
        b=Gm6kpOLHy6G42Nor+nwZs5d5uIthq1SBf8JL5KuXlNePWA3Wi1Na96wwqHbeObADat
         j1O9hn+mMQKHB/eO/E0w/xnikFkOZI7DQC7CjbGufL4kTsZLh3Xvc17DB630dB5FzvLA
         qpT5UJGXopBtMC/HIjDy8I5qTgzQmqt+2u6e5xy9K9RkP1G+rruAqqhM1BxxoksLELfq
         kXE5HyojZMoggHz9POpEVTuU63O8qAPYViFqnPcDQcRt01v6bmlkMWV7NNopTV0kony/
         So83l8ra0tbJgp2LFpaBLAqkP6B8UH1nI3Yn9lfEtbPF4QFI7CAjIoUnLBbks+q1WMt/
         C7KA==
X-Gm-Message-State: APjAAAWaGA1ujx8Gj+0nx7qXqKiCjVov3GZ6hfpKRTb4FbHQNo5Fw43J
        nDPPmtl3wywWImW3HBgCoXs=
X-Google-Smtp-Source: APXvYqzrxsYXF0GmUq/peRBzWINlXtlmZN2iPXhZY9Tc13TaIh7W1CxAz/J5C9QnkPrCvJ4gBxWKvg==
X-Received: by 2002:a5e:9241:: with SMTP id z1mr30495408iop.39.1561010477447;
        Wed, 19 Jun 2019 23:01:17 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t4sm15550991iop.0.2019.06.19.23.01.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 23:01:16 -0700 (PDT)
Date:   Wed, 19 Jun 2019 23:01:10 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Message-ID: <5d0b2126214c3_12352ac65c3c65c06a@john-XPS-13-9370.notmuch>
In-Reply-To: <20190615191225.2409862-4-ast@kernel.org>
References: <20190615191225.2409862-1-ast@kernel.org>
 <20190615191225.2409862-4-ast@kernel.org>
Subject: RE: [PATCH v3 bpf-next 3/9] bpf: extend is_branch_taken to registers
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> This patch extends is_branch_taken() logic from JMP+K instructions
> to JMP+X instructions.
> Conditional branches are often done when src and dst registers
> contain known scalars. In such case the verifier can follow
> the branch that is going to be taken when program executes.
> That speeds up the verification and is essential feature to support
> bounded loops.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
