Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41DD5370C1
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 11:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbfFFJtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 05:49:12 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:33758 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbfFFJtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 05:49:12 -0400
Received: by mail-yw1-f65.google.com with SMTP id k8so627867ywh.0
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 02:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TbM9vdATYDfk/+/NGyr5Ij8vLHhNayhJciB4ayq0pHE=;
        b=zsmhUT89ZCU+vNeRBa0UgwcQ66/LK2vtVlacT4gsa9cFjC90MQ8ROW63aFSV62iPsp
         Zhty+47a4l8hIKT608jS4i4FRWolQ5jbQhFfv9k/mb0f64f2CIV7eBsPlgiXdJOsv5zv
         08PNfooIZ/y0/wggtCO+S4g13FA1Jgim2U9DHC7DsgnH93W4iW2kP2HPvZQNTHOIyAR3
         BXFeaXkSBqi4zatoIlydBllcFCzPF33fE8ZEXzMyR35cxvv+83MpCdF7+H5rytfsWp8U
         A4nsx2Q3AucQw18xPGRYXHNuwx+vGPkJR8k7sacgA5qWAg4h8APJ4SuIjzGint0Bluho
         jGfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TbM9vdATYDfk/+/NGyr5Ij8vLHhNayhJciB4ayq0pHE=;
        b=qBiepYWqEJR024LuAv04T4kqSlyOlhxGBN5zyDY4Neqpr2Qyi0yhCfZg2Y1A3Ael9k
         6YVbGlmgdPuvxYIPRX0QsxW1+rh9xTcj5JTjK66BddDp3xXeCVsBCsyZ4dn6PislgbX2
         FkCl9uvMZXT7Q+t2SeCaUOMswsMrWkuOvpz48dVxNWfnyt3tUB8cD4PjU+osb9oj1kq/
         uVDPgVLtNXVdKcBnr3GBt+obPDi8ZiKq21Zwl+jLZ7ngKKRiC8gobr2TJejMl/6nocBd
         QiBK+sN/9VE4nydnWJXKhTvfBEOIr/PoUDV8SvXQsdP4orXn1XYOLO40dD6qLYM3la0G
         6rcA==
X-Gm-Message-State: APjAAAW/4K9SctlsxUhtVxebtNU7x87VM18Vcdti0zHsGNuB/d+WDG/O
        Dn+JQki8pWOVFdLCxR04531PHDobWLA6Dg==
X-Google-Smtp-Source: APXvYqwY5v7Jc9eFS4HTLF7H5Hxcecyvm/5acFVJP3U5AWwBm5fGLZ41PG9lUrE5d2O+tvJVU66NfA==
X-Received: by 2002:a81:3c90:: with SMTP id j138mr24229019ywa.1.1559814551800;
        Thu, 06 Jun 2019 02:49:11 -0700 (PDT)
Received: from localhost.localdomain (li1322-146.members.linode.com. [45.79.223.146])
        by smtp.gmail.com with ESMTPSA id 85sm357652ywm.64.2019.06.06.02.49.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 02:49:11 -0700 (PDT)
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v2 1/4] perf trace: Exit when build eBPF program failure
Date:   Thu,  6 Jun 2019 17:48:42 +0800
Message-Id: <20190606094845.4800-2-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606094845.4800-1-leo.yan@linaro.org>
References: <20190606094845.4800-1-leo.yan@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On my Juno board with ARM64 CPUs, perf trace command reports the eBPF
program building failure but the command will not exit and continue to
run.  If we define an eBPF event in config file, the event will be
parsed with below flow:

  perf_config()
    `> trace__config()
	 `> parse_events_option()
	      `> parse_events__scanner()
	           `-> parse_events_parse()
	                 `> parse_events_load_bpf()
	                      `> llvm__compile_bpf()

Though the low level functions return back error values when detect eBPF
building failure, but parse_events_option() returns 1 for this case and
trace__config() passes 1 to perf_config(); perf_config() doesn't treat
the returned value 1 as failure and it continues to parse other
configurations.  Thus the perf command continues to run even without
enabling eBPF event successfully.

This patch changes error handling in trace__config(), when it detects
failure it will return -1 rather than directly pass error value (1);
finally, perf_config() will directly bail out and perf will exit for
this case.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 tools/perf/builtin-trace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 54b2d0fd0d02..4b5d004aab74 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -3664,6 +3664,14 @@ static int trace__config(const char *var, const char *value, void *arg)
 					       "event selector. use 'perf list' to list available events",
 					       parse_events_option);
 		err = parse_events_option(&o, value, 0);
+
+		/*
+		 * When parse option successfully parse_events_option() will
+		 * return 0, otherwise means the paring failure.  And it
+		 * returns 1 for eBPF program building failure; so adjust the
+		 * err value to -1 for the failure.
+		 */
+		err = err ? -1 : 0;
 	} else if (!strcmp(var, "trace.show_timestamp")) {
 		trace->show_tstamp = perf_config_bool(var, value);
 	} else if (!strcmp(var, "trace.show_duration")) {
-- 
2.17.1

