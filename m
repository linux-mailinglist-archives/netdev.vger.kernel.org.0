Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5F412A8AA
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 18:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfLYR0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 12:26:03 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36100 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfLYR0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 12:26:02 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so4633653wma.1;
        Wed, 25 Dec 2019 09:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IyYGqQFecW6olPPgmzeJyVPEkoRBYVu64xh+00zPtzs=;
        b=NB6soWLvh0oz/Dx+XjuatUTGv7VqcLYHhvxnX5aHhcVc/k1H4NXGzB89ixtjWz5Qd6
         aQCjEy13bX2FRcdF74VlfJjtwTZuFY8ZgnPNt3ri59S9lxGGyjUqI72OPPCvMfNISy/f
         gavpz6QMYI6nxJwDaMIHX+Q0LlNrPhhNLTIVEyniNp2FQOjixsKP6c9yDyDg+Wy/HWUa
         ueq2fjjpApzhoYKEm5baOgmPziLoJb67KLWf4071msKkvP4N80INAHOgU76UqeGjKgSW
         A+l819aHWWwsYceDpeD1ukheCuqRYI1pAd9OvboBcGQvoRvhup90JvW6JfCxqWytE5Eu
         Fgxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IyYGqQFecW6olPPgmzeJyVPEkoRBYVu64xh+00zPtzs=;
        b=EXnEM2ojis+LwAEdmzDBRBCGxEVGECWSlTDqdsP0+SaOGA+kSb990ChMKMutHXT1fy
         lwmo4NrNVoBIuroka2ZTb5hm6IMckvC059OmqVSPFed3Y9MFWVCslaxoOYg/lXlBMi1g
         c4g4KuB6KoRAOC4oC48NkAUej63z6O48CuHMmHQZsVydw59U2Xz4z+Dnjmnbj9uH9yha
         dRwGNmhXq9h5IT86gFqLp3IWFTlkY+NVkOxCaAPj2MUGXJLTZkuUTOskBd2wsyCHrIU9
         hW79MvjIzHs9APIIL5K6zPoyyY1hpylBAADe00nHeLUjFQcrzfj6ux6D7zLuUVLfQaUv
         cJ/w==
X-Gm-Message-State: APjAAAVFQ16C/WLH/hDwBQu7HXK4bzOiUxLtD5d0fLn8tKzpAcoGgmv5
        VxC7jdbE7Tba6uMRdmnQSQvliss=
X-Google-Smtp-Source: APXvYqwVMXAsZVOBUW7JDoOeOj04fhnVlf8XwmMypCr4jf6gq08kfmv9QPk0jU0BFY3bPyAiTsEF8w==
X-Received: by 2002:a1c:ddc5:: with SMTP id u188mr9591934wmg.83.1577294752058;
        Wed, 25 Dec 2019 09:25:52 -0800 (PST)
Received: from avx2 ([46.53.254.76])
        by smtp.gmail.com with ESMTPSA id a14sm30091122wrx.81.2019.12.25.09.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 09:25:51 -0800 (PST)
Date:   Wed, 25 Dec 2019 20:25:46 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     akpm@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/2] proc: convert everything to "struct proc_ops"
Message-ID: <20191225172546.GB13378@avx2>
References: <20191225172228.GA13378@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191225172228.GA13378@avx2>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The most notable change is DEFINE_SHOW_ATTRIBUTE macro split in
seq_file.h.

Conversion rule is:

	llseek		=> proc_lseek
	unlocked_ioctl	=> proc_ioctl

	xxx		=> proc_xxx

	delete ".owner = THIS_MODULE" line

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

	NON BISECTABLE CHANGE
	MERGE INTO PREVIOUS PATCH!

 arch/alpha/kernel/srm_env.c                           |   17 +-
 arch/arm/kernel/atags_proc.c                          |    8 -
 arch/arm/mm/alignment.c                               |   14 +-
 arch/ia64/kernel/salinfo.c                            |   24 ++--
 arch/m68k/kernel/bootinfo_proc.c                      |    8 -
 arch/mips/lasat/picvue_proc.c                         |   31 ++---
 arch/powerpc/kernel/proc_powerpc.c                    |   10 -
 arch/powerpc/kernel/rtas-proc.c                       |   70 +++++------
 arch/powerpc/kernel/rtas_flash.c                      |   34 ++---
 arch/powerpc/kernel/rtasd.c                           |   14 +-
 arch/powerpc/mm/numa.c                                |   12 +-
 arch/powerpc/platforms/pseries/lpar.c                 |   24 ++--
 arch/powerpc/platforms/pseries/lparcfg.c              |   14 +-
 arch/powerpc/platforms/pseries/reconfig.c             |    8 -
 arch/powerpc/platforms/pseries/scanlog.c              |   15 +-
 arch/sh/mm/alignment.c                                |   17 +-
 arch/sparc/kernel/led.c                               |   15 +-
 arch/um/drivers/mconsole_kern.c                       |    9 -
 arch/um/kernel/exitcode.c                             |   15 +-
 arch/um/kernel/process.c                              |   15 +-
 arch/x86/kernel/apic/x2apic_uv_x.c                    |   26 ++--
 arch/x86/kernel/cpu/mtrr/if.c                         |   21 +--
 arch/x86/platform/uv/tlb_uv.c                         |   14 +-
 arch/xtensa/platforms/iss/simdisk.c                   |   10 -
 drivers/acpi/battery.c                                |   15 +-
 drivers/acpi/proc.c                                   |   15 +-
 drivers/hwmon/dell-smm-hwmon.c                        |   15 +-
 drivers/ide/ide-proc.c                                |   19 +--
 drivers/input/input.c                                 |   28 ++--
 drivers/macintosh/via-pmu.c                           |   17 +-
 drivers/md/md.c                                       |   15 +-
 drivers/misc/sgi-gru/gruprocfs.c                      |   42 +++----
 drivers/net/wireless/cisco/airo.c                     |   98 +++++++---------
 drivers/net/wireless/intel/ipw2x00/libipw_module.c    |   15 +-
 drivers/net/wireless/intersil/hostap/hostap_hw.c      |    4 
 drivers/net/wireless/intersil/hostap/hostap_proc.c    |   14 +-
 drivers/net/wireless/intersil/hostap/hostap_wlan.h    |    2 
 drivers/net/wireless/ray_cs.c                         |   20 +--
 drivers/parisc/led.c                                  |   17 +-
 drivers/pci/proc.c                                    |   25 ++--
 drivers/platform/x86/thinkpad_acpi.c                  |   15 +-
 drivers/platform/x86/toshiba_acpi.c                   |   60 ++++------
 drivers/pnp/isapnp/proc.c                             |    9 -
 drivers/pnp/pnpbios/proc.c                            |   17 +-
 drivers/s390/block/dasd_proc.c                        |   15 +-
 drivers/s390/cio/blacklist.c                          |   14 +-
 drivers/s390/cio/css.c                                |   11 -
 drivers/scsi/esas2r/esas2r_main.c                     |    9 +
 drivers/scsi/scsi_devinfo.c                           |   15 +-
 drivers/scsi/scsi_proc.c                              |   29 ++--
 drivers/scsi/sg.c                                     |   30 ++---
 drivers/staging/isdn/hysdn/hysdn_procconf.c           |   15 +-
 drivers/staging/isdn/hysdn/hysdn_proclog.c            |   17 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_module.c |   14 +-
 drivers/tty/sysrq.c                                   |    8 -
 drivers/usb/gadget/function/rndis.c                   |   17 +-
 drivers/video/fbdev/via/viafbdev.c                    |  105 ++++++++---------
 drivers/zorro/proc.c                                  |    9 -
 fs/cifs/cifs_debug.c                                  |  108 +++++++++---------
 fs/cifs/dfs_cache.c                                   |   13 +-
 fs/cifs/dfs_cache.h                                   |    2 
 fs/fscache/internal.h                                 |    2 
 fs/fscache/object-list.c                              |   11 +
 fs/fscache/proc.c                                     |    2 
 fs/jbd2/journal.c                                     |   13 +-
 fs/jfs/jfs_debug.c                                    |   14 +-
 fs/lockd/procfs.c                                     |   12 +-
 fs/nfsd/nfsctl.c                                      |   13 +-
 fs/nfsd/stats.c                                       |   12 +-
 fs/proc/cpuinfo.c                                     |   12 +-
 fs/proc/kcore.c                                       |   13 +-
 fs/proc/kmsg.c                                        |   14 +-
 fs/proc/page.c                                        |   24 ++--
 fs/proc/stat.c                                        |   12 +-
 fs/proc/vmcore.c                                      |   10 -
 include/linux/seq_file.h                              |   13 ++
 include/linux/sunrpc/stats.h                          |    4 
 ipc/util.c                                            |   14 +-
 kernel/configs.c                                      |    9 -
 kernel/irq/proc.c                                     |   42 +++----
 kernel/kallsyms.c                                     |   12 +-
 kernel/latencytop.c                                   |   14 +-
 kernel/locking/lockdep_proc.c                         |   15 +-
 kernel/module.c                                       |   12 +-
 kernel/profile.c                                      |   24 ++--
 kernel/sched/psi.c                                    |   48 ++++----
 mm/slab_common.c                                      |   15 +-
 mm/swapfile.c                                         |   14 +-
 net/atm/mpoa_proc.c                                   |   17 +-
 net/atm/proc.c                                        |    8 -
 net/core/pktgen.c                                     |   44 +++----
 net/ipv4/ipconfig.c                                   |   10 -
 net/ipv4/netfilter/ipt_CLUSTERIP.c                    |   16 +-
 net/ipv4/route.c                                      |   24 ++--
 net/netfilter/xt_recent.c                             |   17 +-
 net/sunrpc/auth_gss/svcauth_gss.c                     |   10 -
 net/sunrpc/cache.c                                    |   45 +++----
 net/sunrpc/stats.c                                    |   21 +--
 samples/kfifo/bytestream-example.c                    |   11 -
 samples/kfifo/inttype-example.c                       |   11 -
 samples/kfifo/record-example.c                        |   11 -
 sound/core/info.c                                     |   36 ++----
 102 files changed, 986 insertions(+), 1033 deletions(-)

--- a/arch/alpha/kernel/srm_env.c
+++ b/arch/alpha/kernel/srm_env.c
@@ -119,13 +119,12 @@ static ssize_t srm_env_proc_write(struct file *file, const char __user *buffer,
 	return res;
 }
 
-static const struct file_operations srm_env_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= srm_env_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= srm_env_proc_write,
+static const struct proc_ops srm_env_proc_ops = {
+	.proc_open	= srm_env_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= srm_env_proc_write,
 };
 
 static int __init
@@ -182,7 +181,7 @@ srm_env_init(void)
 	entry = srm_named_entries;
 	while (entry->name && entry->id) {
 		if (!proc_create_data(entry->name, 0644, named_dir,
-			     &srm_env_proc_fops, (void *)entry->id))
+			     &srm_env_proc_ops, (void *)entry->id))
 			goto cleanup;
 		entry++;
 	}
@@ -194,7 +193,7 @@ srm_env_init(void)
 		char name[4];
 		sprintf(name, "%ld", var_num);
 		if (!proc_create_data(name, 0644, numbered_dir,
-			     &srm_env_proc_fops, (void *)var_num))
+			     &srm_env_proc_ops, (void *)var_num))
 			goto cleanup;
 	}
 
--- a/arch/arm/kernel/atags_proc.c
+++ b/arch/arm/kernel/atags_proc.c
@@ -17,9 +17,9 @@ static ssize_t atags_read(struct file *file, char __user *buf,
 	return simple_read_from_buffer(buf, count, ppos, b->data, b->size);
 }
 
-static const struct file_operations atags_fops = {
-	.read = atags_read,
-	.llseek = default_llseek,
+static const struct proc_ops atags_proc_ops = {
+	.proc_read	= atags_read,
+	.proc_lseek	= default_llseek,
 };
 
 #define BOOT_PARAMS_SIZE 1536
@@ -61,7 +61,7 @@ static int __init init_atags_procfs(void)
 	b->size = size;
 	memcpy(b->data, atags_copy, size);
 
-	tags_entry = proc_create_data("atags", 0400, NULL, &atags_fops, b);
+	tags_entry = proc_create_data("atags", 0400, NULL, &atags_proc_ops, b);
 	if (!tags_entry)
 		goto nomem;
 
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -162,12 +162,12 @@ static ssize_t alignment_proc_write(struct file *file, const char __user *buffer
 	return count;
 }
 
-static const struct file_operations alignment_proc_fops = {
-	.open		= alignment_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= alignment_proc_write,
+static const struct proc_ops alignment_proc_ops = {
+	.proc_open	= alignment_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= alignment_proc_write,
 };
 #endif /* CONFIG_PROC_FS */
 
@@ -1016,7 +1016,7 @@ static int __init alignment_init(void)
 	struct proc_dir_entry *res;
 
 	res = proc_create("cpu/alignment", S_IWUSR | S_IRUGO, NULL,
-			  &alignment_proc_fops);
+			  &alignment_proc_ops);
 	if (!res)
 		return -ENOMEM;
 #endif
--- a/arch/ia64/kernel/salinfo.c
+++ b/arch/ia64/kernel/salinfo.c
@@ -331,10 +331,10 @@ salinfo_event_read(struct file *file, char __user *buffer, size_t count, loff_t
 	return size;
 }
 
-static const struct file_operations salinfo_event_fops = {
-	.open  = salinfo_event_open,
-	.read  = salinfo_event_read,
-	.llseek = noop_llseek,
+static const struct proc_ops salinfo_event_proc_ops = {
+	.proc_open	= salinfo_event_open,
+	.proc_read	= salinfo_event_read,
+	.proc_lseek	= noop_llseek,
 };
 
 static int
@@ -534,12 +534,12 @@ salinfo_log_write(struct file *file, const char __user *buffer, size_t count, lo
 	return count;
 }
 
-static const struct file_operations salinfo_data_fops = {
-	.open    = salinfo_log_open,
-	.release = salinfo_log_release,
-	.read    = salinfo_log_read,
-	.write   = salinfo_log_write,
-	.llseek  = default_llseek,
+static const struct proc_ops salinfo_data_proc_ops = {
+	.proc_open	= salinfo_log_open,
+	.proc_release	= salinfo_log_release,
+	.proc_read	= salinfo_log_read,
+	.proc_write	= salinfo_log_write,
+	.proc_lseek	= default_llseek,
 };
 
 static int salinfo_cpu_online(unsigned int cpu)
@@ -617,13 +617,13 @@ salinfo_init(void)
 			continue;
 
 		entry = proc_create_data("event", S_IRUSR, dir,
-					 &salinfo_event_fops, data);
+					 &salinfo_event_proc_ops, data);
 		if (!entry)
 			continue;
 		*sdir++ = entry;
 
 		entry = proc_create_data("data", S_IRUSR | S_IWUSR, dir,
-					 &salinfo_data_fops, data);
+					 &salinfo_data_proc_ops, data);
 		if (!entry)
 			continue;
 		*sdir++ = entry;
--- a/arch/m68k/kernel/bootinfo_proc.c
+++ b/arch/m68k/kernel/bootinfo_proc.c
@@ -26,9 +26,9 @@ static ssize_t bootinfo_read(struct file *file, char __user *buf,
 				       bootinfo_size);
 }
 
-static const struct file_operations bootinfo_fops = {
-	.read = bootinfo_read,
-	.llseek = default_llseek,
+static const struct proc_ops bootinfo_proc_ops = {
+	.proc_read	= bootinfo_read,
+	.proc_lseek	= default_llseek,
 };
 
 void __init save_bootinfo(const struct bi_record *bi)
@@ -67,7 +67,7 @@ static int __init init_bootinfo_procfs(void)
 	if (!bootinfo_copy)
 		return -ENOMEM;
 
-	pde = proc_create_data("bootinfo", 0400, NULL, &bootinfo_fops, NULL);
+	pde = proc_create_data("bootinfo", 0400, NULL, &bootinfo_proc_ops, NULL);
 	if (!pde) {
 		kfree(bootinfo_copy);
 		return -ENOMEM;
--- a/arch/mips/lasat/picvue_proc.c
+++ b/arch/mips/lasat/picvue_proc.c
@@ -89,13 +89,12 @@ static ssize_t pvc_line_proc_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static const struct file_operations pvc_line_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= pvc_line_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= pvc_line_proc_write,
+static const struct proc_ops pvc_line_proc_ops = {
+	.proc_open	= pvc_line_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= pvc_line_proc_write,
 };
 
 static ssize_t pvc_scroll_proc_write(struct file *file, const char __user *buf,
@@ -148,13 +147,12 @@ static int pvc_scroll_proc_open(struct inode *inode, struct file *file)
 	return single_open(file, pvc_scroll_proc_show, NULL);
 }
 
-static const struct file_operations pvc_scroll_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= pvc_scroll_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= pvc_scroll_proc_write,
+static const struct proc_ops pvc_scroll_proc_ops = {
+	.proc_open	= pvc_scroll_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= pvc_scroll_proc_write,
 };
 
 void pvc_proc_timerfunc(struct timer_list *unused)
@@ -189,12 +187,11 @@ static int __init pvc_proc_init(void)
 	}
 	for (i = 0; i < PVC_NLINES; i++) {
 		proc_entry = proc_create_data(pvc_linename[i], 0644, dir,
-					&pvc_line_proc_fops, &pvc_linedata[i]);
+					&pvc_line_proc_ops, &pvc_linedata[i]);
 		if (proc_entry == NULL)
 			goto error;
 	}
-	proc_entry = proc_create("scroll", 0644, dir,
-				 &pvc_scroll_proc_fops);
+	proc_entry = proc_create("scroll", 0644, dir, &pvc_scroll_proc_ops);
 	if (proc_entry == NULL)
 		goto error;
 
--- a/arch/powerpc/kernel/proc_powerpc.c
+++ b/arch/powerpc/kernel/proc_powerpc.c
@@ -39,10 +39,10 @@ static int page_map_mmap( struct file *file, struct vm_area_struct *vma )
 	return 0;
 }
 
-static const struct file_operations page_map_fops = {
-	.llseek	= page_map_seek,
-	.read	= page_map_read,
-	.mmap	= page_map_mmap
+static const struct proc_ops page_map_proc_ops = {
+	.proc_lseek	= page_map_seek,
+	.proc_read	= page_map_read,
+	.proc_mmap	= page_map_mmap,
 };
 
 
@@ -51,7 +51,7 @@ static int __init proc_ppc64_init(void)
 	struct proc_dir_entry *pde;
 
 	pde = proc_create_data("powerpc/systemcfg", S_IFREG | 0444, NULL,
-			       &page_map_fops, vdso_data);
+			       &page_map_proc_ops, vdso_data);
 	if (!pde)
 		return 1;
 	proc_set_size(pde, PAGE_SIZE);
--- a/arch/powerpc/kernel/rtas-proc.c
+++ b/arch/powerpc/kernel/rtas-proc.c
@@ -159,12 +159,12 @@ static int poweron_open(struct inode *inode, struct file *file)
 	return single_open(file, ppc_rtas_poweron_show, NULL);
 }
 
-static const struct file_operations ppc_rtas_poweron_operations = {
-	.open		= poweron_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.write		= ppc_rtas_poweron_write,
-	.release	= single_release,
+static const struct proc_ops ppc_rtas_poweron_proc_ops = {
+	.proc_open	= poweron_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= ppc_rtas_poweron_write,
+	.proc_release	= single_release,
 };
 
 static int progress_open(struct inode *inode, struct file *file)
@@ -172,12 +172,12 @@ static int progress_open(struct inode *inode, struct file *file)
 	return single_open(file, ppc_rtas_progress_show, NULL);
 }
 
-static const struct file_operations ppc_rtas_progress_operations = {
-	.open		= progress_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.write		= ppc_rtas_progress_write,
-	.release	= single_release,
+static const struct proc_ops ppc_rtas_progress_proc_ops = {
+	.proc_open	= progress_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= ppc_rtas_progress_write,
+	.proc_release	= single_release,
 };
 
 static int clock_open(struct inode *inode, struct file *file)
@@ -185,12 +185,12 @@ static int clock_open(struct inode *inode, struct file *file)
 	return single_open(file, ppc_rtas_clock_show, NULL);
 }
 
-static const struct file_operations ppc_rtas_clock_operations = {
-	.open		= clock_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.write		= ppc_rtas_clock_write,
-	.release	= single_release,
+static const struct proc_ops ppc_rtas_clock_proc_ops = {
+	.proc_open	= clock_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= ppc_rtas_clock_write,
+	.proc_release	= single_release,
 };
 
 static int tone_freq_open(struct inode *inode, struct file *file)
@@ -198,12 +198,12 @@ static int tone_freq_open(struct inode *inode, struct file *file)
 	return single_open(file, ppc_rtas_tone_freq_show, NULL);
 }
 
-static const struct file_operations ppc_rtas_tone_freq_operations = {
-	.open		= tone_freq_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.write		= ppc_rtas_tone_freq_write,
-	.release	= single_release,
+static const struct proc_ops ppc_rtas_tone_freq_proc_ops = {
+	.proc_open	= tone_freq_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= ppc_rtas_tone_freq_write,
+	.proc_release	= single_release,
 };
 
 static int tone_volume_open(struct inode *inode, struct file *file)
@@ -211,12 +211,12 @@ static int tone_volume_open(struct inode *inode, struct file *file)
 	return single_open(file, ppc_rtas_tone_volume_show, NULL);
 }
 
-static const struct file_operations ppc_rtas_tone_volume_operations = {
-	.open		= tone_volume_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.write		= ppc_rtas_tone_volume_write,
-	.release	= single_release,
+static const struct proc_ops ppc_rtas_tone_volume_proc_ops = {
+	.proc_open	= tone_volume_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= ppc_rtas_tone_volume_write,
+	.proc_release	= single_release,
 };
 
 static int ppc_rtas_find_all_sensors(void);
@@ -238,17 +238,17 @@ static int __init proc_rtas_init(void)
 		return -ENODEV;
 
 	proc_create("powerpc/rtas/progress", 0644, NULL,
-		    &ppc_rtas_progress_operations);
+		    &ppc_rtas_progress_proc_ops);
 	proc_create("powerpc/rtas/clock", 0644, NULL,
-		    &ppc_rtas_clock_operations);
+		    &ppc_rtas_clock_proc_ops);
 	proc_create("powerpc/rtas/poweron", 0644, NULL,
-		    &ppc_rtas_poweron_operations);
+		    &ppc_rtas_poweron_proc_ops);
 	proc_create_single("powerpc/rtas/sensors", 0444, NULL,
 			ppc_rtas_sensors_show);
 	proc_create("powerpc/rtas/frequency", 0644, NULL,
-		    &ppc_rtas_tone_freq_operations);
+		    &ppc_rtas_tone_freq_proc_ops);
 	proc_create("powerpc/rtas/volume", 0644, NULL,
-		    &ppc_rtas_tone_volume_operations);
+		    &ppc_rtas_tone_volume_proc_ops);
 	proc_create_single("powerpc/rtas/rmo_buffer", 0400, NULL,
 			ppc_rtas_rmo_buf_show);
 	return 0;
--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@ -655,7 +655,7 @@ struct rtas_flash_file {
 	const char *filename;
 	const char *rtas_call_name;
 	int *status;
-	const struct file_operations fops;
+	const struct proc_ops ops;
 };
 
 static const struct rtas_flash_file rtas_flash_files[] = {
@@ -663,36 +663,36 @@ static const struct rtas_flash_file rtas_flash_files[] = {
 		.filename	= "powerpc/rtas/" FIRMWARE_FLASH_NAME,
 		.rtas_call_name	= "ibm,update-flash-64-and-reboot",
 		.status		= &rtas_update_flash_data.status,
-		.fops.read	= rtas_flash_read_msg,
-		.fops.write	= rtas_flash_write,
-		.fops.release	= rtas_flash_release,
-		.fops.llseek	= default_llseek,
+		.ops.proc_read	= rtas_flash_read_msg,
+		.ops.proc_write	= rtas_flash_write,
+		.ops.proc_release = rtas_flash_release,
+		.ops.proc_lseek	= default_llseek,
 	},
 	{
 		.filename	= "powerpc/rtas/" FIRMWARE_UPDATE_NAME,
 		.rtas_call_name	= "ibm,update-flash-64-and-reboot",
 		.status		= &rtas_update_flash_data.status,
-		.fops.read	= rtas_flash_read_num,
-		.fops.write	= rtas_flash_write,
-		.fops.release	= rtas_flash_release,
-		.fops.llseek	= default_llseek,
+		.ops.proc_read	= rtas_flash_read_num,
+		.ops.proc_write	= rtas_flash_write,
+		.ops.proc_release = rtas_flash_release,
+		.ops.proc_lseek	= default_llseek,
 	},
 	{
 		.filename	= "powerpc/rtas/" VALIDATE_FLASH_NAME,
 		.rtas_call_name	= "ibm,validate-flash-image",
 		.status		= &rtas_validate_flash_data.status,
-		.fops.read	= validate_flash_read,
-		.fops.write	= validate_flash_write,
-		.fops.release	= validate_flash_release,
-		.fops.llseek	= default_llseek,
+		.ops.proc_read	= validate_flash_read,
+		.ops.proc_write	= validate_flash_write,
+		.ops.proc_release = validate_flash_release,
+		.ops.proc_lseek	= default_llseek,
 	},
 	{
 		.filename	= "powerpc/rtas/" MANAGE_FLASH_NAME,
 		.rtas_call_name	= "ibm,manage-flash-image",
 		.status		= &rtas_manage_flash_data.status,
-		.fops.read	= manage_flash_read,
-		.fops.write	= manage_flash_write,
-		.fops.llseek	= default_llseek,
+		.ops.proc_read	= manage_flash_read,
+		.ops.proc_write	= manage_flash_write,
+		.ops.proc_lseek	= default_llseek,
 	}
 };
 
@@ -723,7 +723,7 @@ static int __init rtas_flash_init(void)
 		const struct rtas_flash_file *f = &rtas_flash_files[i];
 		int token;
 
-		if (!proc_create(f->filename, 0600, NULL, &f->fops))
+		if (!proc_create(f->filename, 0600, NULL, &f->ops))
 			goto enomem;
 
 		/*
--- a/arch/powerpc/kernel/rtasd.c
+++ b/arch/powerpc/kernel/rtasd.c
@@ -385,12 +385,12 @@ static __poll_t rtas_log_poll(struct file *file, poll_table * wait)
 	return 0;
 }
 
-static const struct file_operations proc_rtas_log_operations = {
-	.read =		rtas_log_read,
-	.poll =		rtas_log_poll,
-	.open =		rtas_log_open,
-	.release =	rtas_log_release,
-	.llseek =	noop_llseek,
+static const struct proc_ops rtas_log_proc_ops = {
+	.proc_read	= rtas_log_read,
+	.proc_poll	= rtas_log_poll,
+	.proc_open	= rtas_log_open,
+	.proc_release	= rtas_log_release,
+	.proc_lseek	= noop_llseek,
 };
 
 static int enable_surveillance(int timeout)
@@ -572,7 +572,7 @@ static int __init rtas_init(void)
 		return -ENODEV;
 
 	entry = proc_create("powerpc/rtas/error_log", 0400, NULL,
-			    &proc_rtas_log_operations);
+			    &rtas_log_proc_ops);
 	if (!entry)
 		printk(KERN_ERR "Failed to create error_log proc entry\n");
 
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -1616,11 +1616,11 @@ static ssize_t topology_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static const struct file_operations topology_ops = {
-	.read = seq_read,
-	.write = topology_write,
-	.open = topology_open,
-	.release = single_release
+static const struct proc_ops topology_proc_ops = {
+	.proc_read	= seq_read,
+	.proc_write	= topology_write,
+	.proc_open	= topology_open,
+	.proc_release	= single_release,
 };
 
 static int topology_update_init(void)
@@ -1630,7 +1630,7 @@ static int topology_update_init(void)
 	if (vphn_enabled)
 		topology_schedule_update();
 
-	if (!proc_create("powerpc/topology_updates", 0644, NULL, &topology_ops))
+	if (!proc_create("powerpc/topology_updates", 0644, NULL, &topology_proc_ops))
 		return -ENOMEM;
 
 	topology_inited = 1;
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -582,12 +582,12 @@ static int vcpudispatch_stats_open(struct inode *inode, struct file *file)
 	return single_open(file, vcpudispatch_stats_display, NULL);
 }
 
-static const struct file_operations vcpudispatch_stats_proc_ops = {
-	.open		= vcpudispatch_stats_open,
-	.read		= seq_read,
-	.write		= vcpudispatch_stats_write,
-	.llseek		= seq_lseek,
-	.release	= single_release,
+static const struct proc_ops vcpudispatch_stats_proc_ops = {
+	.proc_open	= vcpudispatch_stats_open,
+	.proc_read	= seq_read,
+	.proc_write	= vcpudispatch_stats_write,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
 };
 
 static ssize_t vcpudispatch_stats_freq_write(struct file *file,
@@ -626,12 +626,12 @@ static int vcpudispatch_stats_freq_open(struct inode *inode, struct file *file)
 	return single_open(file, vcpudispatch_stats_freq_display, NULL);
 }
 
-static const struct file_operations vcpudispatch_stats_freq_proc_ops = {
-	.open		= vcpudispatch_stats_freq_open,
-	.read		= seq_read,
-	.write		= vcpudispatch_stats_freq_write,
-	.llseek		= seq_lseek,
-	.release	= single_release,
+static const struct proc_ops vcpudispatch_stats_freq_proc_ops = {
+	.proc_open	= vcpudispatch_stats_freq_open,
+	.proc_read	= seq_read,
+	.proc_write	= vcpudispatch_stats_freq_write,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
 };
 
 static int __init vcpudispatch_stats_procfs_init(void)
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -698,12 +698,12 @@ static int lparcfg_open(struct inode *inode, struct file *file)
 	return single_open(file, lparcfg_data, NULL);
 }
 
-static const struct file_operations lparcfg_fops = {
-	.read		= seq_read,
-	.write		= lparcfg_write,
-	.open		= lparcfg_open,
-	.release	= single_release,
-	.llseek		= seq_lseek,
+static const struct proc_ops lparcfg_proc_ops = {
+	.proc_read	= seq_read,
+	.proc_write	= lparcfg_write,
+	.proc_open	= lparcfg_open,
+	.proc_release	= single_release,
+	.proc_lseek	= seq_lseek,
 };
 
 static int __init lparcfg_init(void)
@@ -714,7 +714,7 @@ static int __init lparcfg_init(void)
 	if (firmware_has_feature(FW_FEATURE_SPLPAR))
 		mode |= 0200;
 
-	if (!proc_create("powerpc/lparcfg", mode, NULL, &lparcfg_fops)) {
+	if (!proc_create("powerpc/lparcfg", mode, NULL, &lparcfg_proc_ops)) {
 		printk(KERN_ERR "Failed to create powerpc/lparcfg\n");
 		return -EIO;
 	}
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -391,9 +391,9 @@ static ssize_t ofdt_write(struct file *file, const char __user *buf, size_t coun
 	return rv ? rv : count;
 }
 
-static const struct file_operations ofdt_fops = {
-	.write = ofdt_write,
-	.llseek = noop_llseek,
+static const struct proc_ops ofdt_proc_ops = {
+	.proc_write	= ofdt_write,
+	.proc_lseek	= noop_llseek,
 };
 
 /* create /proc/powerpc/ofdt write-only by root */
@@ -401,7 +401,7 @@ static int proc_ppc64_create_ofdt(void)
 {
 	struct proc_dir_entry *ent;
 
-	ent = proc_create("powerpc/ofdt", 0200, NULL, &ofdt_fops);
+	ent = proc_create("powerpc/ofdt", 0200, NULL, &ofdt_proc_ops);
 	if (ent)
 		proc_set_size(ent, 0);
 
--- a/arch/powerpc/platforms/pseries/scanlog.c
+++ b/arch/powerpc/platforms/pseries/scanlog.c
@@ -152,13 +152,12 @@ static int scanlog_release(struct inode * inode, struct file * file)
 	return 0;
 }
 
-static const struct file_operations scanlog_fops = {
-	.owner		= THIS_MODULE,
-	.read		= scanlog_read,
-	.write		= scanlog_write,
-	.open		= scanlog_open,
-	.release	= scanlog_release,
-	.llseek		= noop_llseek,
+static const struct proc_ops scanlog_proc_ops = {
+	.proc_read	= scanlog_read,
+	.proc_write	= scanlog_write,
+	.proc_open	= scanlog_open,
+	.proc_release	= scanlog_release,
+	.proc_lseek	= noop_llseek,
 };
 
 static int __init scanlog_init(void)
@@ -176,7 +175,7 @@ static int __init scanlog_init(void)
 		goto err;
 
 	ent = proc_create("powerpc/rtas/scan-log-dump", 0400, NULL,
-			  &scanlog_fops);
+			  &scanlog_proc_ops);
 	if (!ent)
 		goto err;
 	return 0;
--- a/arch/sh/mm/alignment.c
+++ b/arch/sh/mm/alignment.c
@@ -152,13 +152,12 @@ static ssize_t alignment_proc_write(struct file *file,
 	return count;
 }
 
-static const struct file_operations alignment_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= alignment_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= alignment_proc_write,
+static const struct proc_ops alignment_proc_ops = {
+	.proc_open	= alignment_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= alignment_proc_write,
 };
 
 /*
@@ -176,12 +175,12 @@ static int __init alignment_init(void)
 		return -ENOMEM;
 
 	res = proc_create_data("alignment", S_IWUSR | S_IRUGO, dir,
-			       &alignment_proc_fops, &se_usermode);
+			       &alignment_proc_ops, &se_usermode);
 	if (!res)
 		return -ENOMEM;
 
         res = proc_create_data("kernel_alignment", S_IWUSR | S_IRUGO, dir,
-			       &alignment_proc_fops, &se_kernmode_warn);
+			       &alignment_proc_ops, &se_kernmode_warn);
         if (!res)
                 return -ENOMEM;
 
--- a/arch/sparc/kernel/led.c
+++ b/arch/sparc/kernel/led.c
@@ -104,13 +104,12 @@ static ssize_t led_proc_write(struct file *file, const char __user *buffer,
 	return count;
 }
 
-static const struct file_operations led_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= led_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= led_proc_write,
+static const struct proc_ops led_proc_ops = {
+	.proc_open	= led_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= led_proc_write,
 };
 
 static struct proc_dir_entry *led;
@@ -121,7 +120,7 @@ static int __init led_init(void)
 {
 	timer_setup(&led_blink_timer, led_blink, 0);
 
-	led = proc_create("led", 0, NULL, &led_proc_fops);
+	led = proc_create("led", 0, NULL, &led_proc_ops);
 	if (!led)
 		return -ENOMEM;
 
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -752,10 +752,9 @@ static ssize_t mconsole_proc_write(struct file *file,
 	return count;
 }
 
-static const struct file_operations mconsole_proc_fops = {
-	.owner		= THIS_MODULE,
-	.write		= mconsole_proc_write,
-	.llseek		= noop_llseek,
+static const struct proc_ops mconsole_proc_ops = {
+	.proc_write	= mconsole_proc_write,
+	.proc_lseek	= noop_llseek,
 };
 
 static int create_proc_mconsole(void)
@@ -765,7 +764,7 @@ static int create_proc_mconsole(void)
 	if (notify_socket == NULL)
 		return 0;
 
-	ent = proc_create("mconsole", 0200, NULL, &mconsole_proc_fops);
+	ent = proc_create("mconsole", 0200, NULL, &mconsole_proc_ops);
 	if (ent == NULL) {
 		printk(KERN_INFO "create_proc_mconsole : proc_create failed\n");
 		return 0;
--- a/arch/um/kernel/exitcode.c
+++ b/arch/um/kernel/exitcode.c
@@ -55,20 +55,19 @@ static ssize_t exitcode_proc_write(struct file *file,
 	return count;
 }
 
-static const struct file_operations exitcode_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= exitcode_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= exitcode_proc_write,
+static const struct proc_ops exitcode_proc_ops = {
+	.proc_open	= exitcode_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= exitcode_proc_write,
 };
 
 static int make_proc_exitcode(void)
 {
 	struct proc_dir_entry *ent;
 
-	ent = proc_create("exitcode", 0600, NULL, &exitcode_proc_fops);
+	ent = proc_create("exitcode", 0600, NULL, &exitcode_proc_ops);
 	if (ent == NULL) {
 		printk(KERN_WARNING "make_proc_exitcode : Failed to register "
 		       "/proc/exitcode\n");
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -348,13 +348,12 @@ static ssize_t sysemu_proc_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static const struct file_operations sysemu_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= sysemu_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= sysemu_proc_write,
+static const struct proc_ops sysemu_proc_ops = {
+	.proc_open	= sysemu_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= sysemu_proc_write,
 };
 
 int __init make_proc_sysemu(void)
@@ -363,7 +362,7 @@ int __init make_proc_sysemu(void)
 	if (!sysemu_supported)
 		return 0;
 
-	ent = proc_create("sysemu", 0600, NULL, &sysemu_proc_fops);
+	ent = proc_create("sysemu", 0600, NULL, &sysemu_proc_ops);
 
 	if (ent == NULL)
 	{
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -1527,17 +1527,17 @@ static int proc_oemid_open(struct inode *inode, struct file *file)
 }
 
 /* (struct is "non-const" as open function is set at runtime) */
-static struct file_operations proc_version_fops = {
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
+static struct proc_ops version_proc_ops = {
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
 };
 
-static const struct file_operations proc_oemid_fops = {
-	.open		= proc_oemid_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
+static const struct proc_ops oemid_proc_ops = {
+	.proc_open	= proc_oemid_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
 };
 
 static __init void uv_setup_proc_files(int hubless)
@@ -1546,12 +1546,12 @@ static __init void uv_setup_proc_files(int hubless)
 	char *name = hubless ? "hubless" : "hubbed";
 
 	pde = proc_mkdir(UV_PROC_NODE, NULL);
-	proc_create("oemid", 0, pde, &proc_oemid_fops);
-	proc_create(name, 0, pde, &proc_version_fops);
+	proc_create("oemid", 0, pde, &oemid_proc_ops);
+	proc_create(name, 0, pde, &version_proc_ops);
 	if (hubless)
-		proc_version_fops.open = proc_hubless_open;
+		version_proc_ops.proc_open = proc_hubless_open;
 	else
-		proc_version_fops.open = proc_hubbed_open;
+		version_proc_ops.proc_open = proc_hubbed_open;
 }
 
 /* Initialize UV hubless systems */
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -384,15 +384,16 @@ static int mtrr_open(struct inode *inode, struct file *file)
 	return single_open(file, mtrr_seq_show, NULL);
 }
 
-static const struct file_operations mtrr_fops = {
-	.owner			= THIS_MODULE,
-	.open			= mtrr_open,
-	.read			= seq_read,
-	.llseek			= seq_lseek,
-	.write			= mtrr_write,
-	.unlocked_ioctl		= mtrr_ioctl,
-	.compat_ioctl		= mtrr_ioctl,
-	.release		= mtrr_close,
+static const struct proc_ops mtrr_proc_ops = {
+	.proc_open		= mtrr_open,
+	.proc_read		= seq_read,
+	.proc_lseek		= seq_lseek,
+	.proc_write		= mtrr_write,
+	.proc_ioctl		= mtrr_ioctl,
+#ifdef CONFIG_COMPAT
+	.proc_compat_ioctl	= mtrr_ioctl,
+#endif
+	.proc_release		= mtrr_close,
 };
 
 static int mtrr_seq_show(struct seq_file *seq, void *offset)
@@ -436,7 +437,7 @@ static int __init mtrr_if_init(void)
 	    (!cpu_has(c, X86_FEATURE_CENTAUR_MCR)))
 		return -ENODEV;
 
-	proc_create("mtrr", S_IWUSR | S_IRUGO, NULL, &mtrr_fops);
+	proc_create("mtrr", S_IWUSR | S_IRUGO, NULL, &mtrr_proc_ops);
 	return 0;
 }
 arch_initcall(mtrr_if_init);
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1668,12 +1668,12 @@ static int tunables_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static const struct file_operations proc_uv_ptc_operations = {
-	.open		= ptc_proc_open,
-	.read		= seq_read,
-	.write		= ptc_proc_write,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
+static const struct proc_ops uv_ptc_proc_ops = {
+	.proc_open	= ptc_proc_open,
+	.proc_read	= seq_read,
+	.proc_write	= ptc_proc_write,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release,
 };
 
 static const struct file_operations tunables_fops = {
@@ -1691,7 +1691,7 @@ static int __init uv_ptc_init(void)
 		return 0;
 
 	proc_uv_ptc = proc_create(UV_PTC_BASENAME, 0444, NULL,
-				  &proc_uv_ptc_operations);
+				  &uv_ptc_proc_ops);
 	if (!proc_uv_ptc) {
 		pr_err("unable to create %s proc entry\n",
 		       UV_PTC_BASENAME);
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -251,10 +251,10 @@ static ssize_t proc_write_simdisk(struct file *file, const char __user *buf,
 	return err;
 }
 
-static const struct file_operations fops = {
-	.read = proc_read_simdisk,
-	.write = proc_write_simdisk,
-	.llseek = default_llseek,
+static const struct proc_ops simdisk_proc_ops = {
+	.proc_read	= proc_read_simdisk,
+	.proc_write	= proc_write_simdisk,
+	.proc_lseek	= default_llseek,
 };
 
 static int __init simdisk_setup(struct simdisk *dev, int which,
@@ -290,7 +290,7 @@ static int __init simdisk_setup(struct simdisk *dev, int which,
 	set_capacity(dev->gd, 0);
 	add_disk(dev->gd);
 
-	dev->procfile = proc_create_data(tmp, 0644, procdir, &fops, dev);
+	dev->procfile = proc_create_data(tmp, 0644, procdir, &simdisk_proc_ops, dev);
 	return 0;
 
 out_alloc_disk:
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -1165,13 +1165,12 @@ static int acpi_battery_alarm_proc_open(struct inode *inode, struct file *file)
 	return single_open(file, acpi_battery_alarm_proc_show, PDE_DATA(inode));
 }
 
-static const struct file_operations acpi_battery_alarm_fops = {
-	.owner		= THIS_MODULE,
-	.open		= acpi_battery_alarm_proc_open,
-	.read		= seq_read,
-	.write		= acpi_battery_write_alarm,
-	.llseek		= seq_lseek,
-	.release	= single_release,
+static const struct proc_ops acpi_battery_alarm_proc_ops = {
+	.proc_open	= acpi_battery_alarm_proc_open,
+	.proc_read	= seq_read,
+	.proc_write	= acpi_battery_write_alarm,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
 };
 
 static int acpi_battery_add_fs(struct acpi_device *device)
@@ -1191,7 +1190,7 @@ static int acpi_battery_add_fs(struct acpi_device *device)
 			acpi_battery_state_proc_show, acpi_driver_data(device)))
 		return -ENODEV;
 	if (!proc_create_data("alarm", S_IFREG | S_IRUGO | S_IWUSR,
-			acpi_device_dir(device), &acpi_battery_alarm_fops,
+			acpi_device_dir(device), &acpi_battery_alarm_proc_ops,
 			acpi_driver_data(device)))
 		return -ENODEV;
 	return 0;
--- a/drivers/acpi/proc.c
+++ b/drivers/acpi/proc.c
@@ -136,18 +136,17 @@ acpi_system_wakeup_device_open_fs(struct inode *inode, struct file *file)
 			   PDE_DATA(inode));
 }
 
-static const struct file_operations acpi_system_wakeup_device_fops = {
-	.owner = THIS_MODULE,
-	.open = acpi_system_wakeup_device_open_fs,
-	.read = seq_read,
-	.write = acpi_system_write_wakeup_device,
-	.llseek = seq_lseek,
-	.release = single_release,
+static const struct proc_ops acpi_system_wakeup_device_proc_ops = {
+	.proc_open	= acpi_system_wakeup_device_open_fs,
+	.proc_read	= seq_read,
+	.proc_write	= acpi_system_write_wakeup_device,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
 };
 
 void __init acpi_sleep_proc_init(void)
 {
 	/* 'wakeup device' [R/W] */
 	proc_create("wakeup", S_IFREG | S_IRUGO | S_IWUSR,
-		    acpi_root_dir, &acpi_system_wakeup_device_fops);
+		    acpi_root_dir, &acpi_system_wakeup_device_proc_ops);
 }
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -595,19 +595,18 @@ static int i8k_open_fs(struct inode *inode, struct file *file)
 	return single_open(file, i8k_proc_show, NULL);
 }
 
-static const struct file_operations i8k_fops = {
-	.owner		= THIS_MODULE,
-	.open		= i8k_open_fs,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.unlocked_ioctl	= i8k_ioctl,
+static const struct proc_ops i8k_proc_ops = {
+	.proc_open	= i8k_open_fs,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_ioctl	= i8k_ioctl,
 };
 
 static void __init i8k_init_procfs(void)
 {
 	/* Register the proc entry */
-	proc_create("i8k", 0, NULL, &i8k_fops);
+	proc_create("i8k", 0, NULL, &i8k_proc_ops);
 }
 
 static void __exit i8k_exit_procfs(void)
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -381,13 +381,12 @@ static ssize_t ide_settings_proc_write(struct file *file, const char __user *buf
 	return -EINVAL;
 }
 
-static const struct file_operations ide_settings_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_settings_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= ide_settings_proc_write,
+static const struct proc_ops ide_settings_proc_ops = {
+	.proc_open	= ide_settings_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= ide_settings_proc_write,
 };
 
 int ide_capacity_proc_show(struct seq_file *m, void *v)
@@ -546,7 +545,7 @@ void ide_proc_port_register_devices(ide_hwif_t *hwif)
 		if (drive->proc) {
 			ide_add_proc_entries(drive->proc, generic_drive_entries, drive);
 			proc_create_data("settings", S_IFREG|S_IRUSR|S_IWUSR,
-					drive->proc, &ide_settings_proc_fops,
+					drive->proc, &ide_settings_proc_ops,
 					drive);
 		}
 		sprintf(name, "ide%d/%s", (drive->name[2]-'a')/2, drive->name);
@@ -615,7 +614,7 @@ static int ide_drivers_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-DEFINE_SHOW_ATTRIBUTE(ide_drivers);
+DEFINE_PROC_SHOW_ATTRIBUTE(ide_drivers);
 
 void proc_ide_create(void)
 {
@@ -624,7 +623,7 @@ void proc_ide_create(void)
 	if (!proc_ide_root)
 		return;
 
-	proc_create("drivers", 0, proc_ide_root, &ide_drivers_fops);
+	proc_create("drivers", 0, proc_ide_root, &ide_drivers_proc_ops);
 }
 
 void proc_ide_destroy(void)
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1210,13 +1210,12 @@ static int input_proc_devices_open(struct inode *inode, struct file *file)
 	return seq_open(file, &input_devices_seq_ops);
 }
 
-static const struct file_operations input_devices_fileops = {
-	.owner		= THIS_MODULE,
-	.open		= input_proc_devices_open,
-	.poll		= input_proc_devices_poll,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
+static const struct proc_ops input_devices_proc_ops = {
+	.proc_open	= input_proc_devices_open,
+	.proc_poll	= input_proc_devices_poll,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release,
 };
 
 static void *input_handlers_seq_start(struct seq_file *seq, loff_t *pos)
@@ -1274,12 +1273,11 @@ static int input_proc_handlers_open(struct inode *inode, struct file *file)
 	return seq_open(file, &input_handlers_seq_ops);
 }
 
-static const struct file_operations input_handlers_fileops = {
-	.owner		= THIS_MODULE,
-	.open		= input_proc_handlers_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
+static const struct proc_ops input_handlers_proc_ops = {
+	.proc_open	= input_proc_handlers_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release,
 };
 
 static int __init input_proc_init(void)
@@ -1291,12 +1289,12 @@ static int __init input_proc_init(void)
 		return -ENOMEM;
 
 	entry = proc_create("devices", 0, proc_bus_input_dir,
-			    &input_devices_fileops);
+			    &input_devices_proc_ops);
 	if (!entry)
 		goto fail1;
 
 	entry = proc_create("handlers", 0, proc_bus_input_dir,
-			    &input_handlers_fileops);
+			    &input_handlers_proc_ops);
 	if (!entry)
 		goto fail2;
 
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -212,7 +212,7 @@ static int pmu_info_proc_show(struct seq_file *m, void *v);
 static int pmu_irqstats_proc_show(struct seq_file *m, void *v);
 static int pmu_battery_proc_show(struct seq_file *m, void *v);
 static void pmu_pass_intr(unsigned char *data, int len);
-static const struct file_operations pmu_options_proc_fops;
+static const struct proc_ops pmu_options_proc_ops;
 
 #ifdef CONFIG_ADB
 const struct adb_driver via_pmu_driver = {
@@ -573,7 +573,7 @@ static int __init via_pmu_dev_init(void)
 		proc_pmu_irqstats = proc_create_single("interrupts", 0,
 				proc_pmu_root, pmu_irqstats_proc_show);
 		proc_pmu_options = proc_create("options", 0600, proc_pmu_root,
-						&pmu_options_proc_fops);
+						&pmu_options_proc_ops);
 	}
 	return 0;
 }
@@ -974,13 +974,12 @@ static ssize_t pmu_options_proc_write(struct file *file,
 	return fcount;
 }
 
-static const struct file_operations pmu_options_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= pmu_options_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= pmu_options_proc_write,
+static const struct proc_ops pmu_options_proc_ops = {
+	.proc_open	= pmu_options_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= pmu_options_proc_write,
 };
 
 #ifdef CONFIG_ADB
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8135,13 +8135,12 @@ static __poll_t mdstat_poll(struct file *filp, poll_table *wait)
 	return mask;
 }
 
-static const struct file_operations md_seq_fops = {
-	.owner		= THIS_MODULE,
-	.open           = md_seq_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release	= seq_release,
-	.poll		= mdstat_poll,
+static const struct proc_ops mdstat_proc_ops = {
+	.proc_open	= md_seq_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release,
+	.proc_poll	= mdstat_poll,
 };
 
 int register_md_personality(struct md_personality *p)
@@ -9310,7 +9309,7 @@ static void md_geninit(void)
 {
 	pr_debug("md: sizeof(mdp_super_t) = %d\n", (int)sizeof(mdp_super_t));
 
-	proc_create("mdstat", S_IRUGO, NULL, &md_seq_fops);
+	proc_create("mdstat", S_IRUGO, NULL, &mdstat_proc_ops);
 }
 
 static int __init md_init(void)
--- a/drivers/misc/sgi-gru/gruprocfs.c
+++ b/drivers/misc/sgi-gru/gruprocfs.c
@@ -255,28 +255,28 @@ static int options_open(struct inode *inode, struct file *file)
 }
 
 /* *INDENT-OFF* */
-static const struct file_operations statistics_fops = {
-	.open 		= statistics_open,
-	.read 		= seq_read,
-	.write 		= statistics_write,
-	.llseek 	= seq_lseek,
-	.release 	= single_release,
+static const struct proc_ops statistics_proc_ops = {
+	.proc_open	= statistics_open,
+	.proc_read	= seq_read,
+	.proc_write	= statistics_write,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
 };
 
-static const struct file_operations mcs_statistics_fops = {
-	.open 		= mcs_statistics_open,
-	.read 		= seq_read,
-	.write 		= mcs_statistics_write,
-	.llseek 	= seq_lseek,
-	.release 	= single_release,
+static const struct proc_ops mcs_statistics_proc_ops = {
+	.proc_open	= mcs_statistics_open,
+	.proc_read	= seq_read,
+	.proc_write	= mcs_statistics_write,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
 };
 
-static const struct file_operations options_fops = {
-	.open 		= options_open,
-	.read 		= seq_read,
-	.write 		= options_write,
-	.llseek 	= seq_lseek,
-	.release 	= single_release,
+static const struct proc_ops options_proc_ops = {
+	.proc_open	= options_open,
+	.proc_read	= seq_read,
+	.proc_write	= options_write,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
 };
 
 static struct proc_dir_entry *proc_gru __read_mostly;
@@ -286,11 +286,11 @@ int gru_proc_init(void)
 	proc_gru = proc_mkdir("sgi_uv/gru", NULL);
 	if (!proc_gru)
 		return -1;
-	if (!proc_create("statistics", 0644, proc_gru, &statistics_fops))
+	if (!proc_create("statistics", 0644, proc_gru, &statistics_proc_ops))
 		goto err;
-	if (!proc_create("mcs_statistics", 0644, proc_gru, &mcs_statistics_fops))
+	if (!proc_create("mcs_statistics", 0644, proc_gru, &mcs_statistics_proc_ops))
 		goto err;
-	if (!proc_create("debug_options", 0644, proc_gru, &options_fops))
+	if (!proc_create("debug_options", 0644, proc_gru, &options_proc_ops))
 		goto err;
 	if (!proc_create_seq("cch_status", 0444, proc_gru, &cch_seq_ops))
 		goto err;
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -4420,73 +4420,65 @@ static int proc_BSSList_open( struct inode *inode, struct file *file );
 static int proc_config_open( struct inode *inode, struct file *file );
 static int proc_wepkey_open( struct inode *inode, struct file *file );
 
-static const struct file_operations proc_statsdelta_ops = {
-	.owner		= THIS_MODULE,
-	.read		= proc_read,
-	.open		= proc_statsdelta_open,
-	.release	= proc_close,
-	.llseek		= default_llseek,
+static const struct proc_ops proc_statsdelta_ops = {
+	.proc_read	= proc_read,
+	.proc_open	= proc_statsdelta_open,
+	.proc_release	= proc_close,
+	.proc_lseek	= default_llseek,
 };
 
-static const struct file_operations proc_stats_ops = {
-	.owner		= THIS_MODULE,
-	.read		= proc_read,
-	.open		= proc_stats_open,
-	.release	= proc_close,
-	.llseek		= default_llseek,
+static const struct proc_ops proc_stats_ops = {
+	.proc_read	= proc_read,
+	.proc_open	= proc_stats_open,
+	.proc_release	= proc_close,
+	.proc_lseek	= default_llseek,
 };
 
-static const struct file_operations proc_status_ops = {
-	.owner		= THIS_MODULE,
-	.read		= proc_read,
-	.open		= proc_status_open,
-	.release	= proc_close,
-	.llseek		= default_llseek,
+static const struct proc_ops proc_status_ops = {
+	.proc_read	= proc_read,
+	.proc_open	= proc_status_open,
+	.proc_release	= proc_close,
+	.proc_lseek	= default_llseek,
 };
 
-static const struct file_operations proc_SSID_ops = {
-	.owner		= THIS_MODULE,
-	.read		= proc_read,
-	.write		= proc_write,
-	.open		= proc_SSID_open,
-	.release	= proc_close,
-	.llseek		= default_llseek,
+static const struct proc_ops proc_SSID_ops = {
+	.proc_read	= proc_read,
+	.proc_write	= proc_write,
+	.proc_open	= proc_SSID_open,
+	.proc_release	= proc_close,
+	.proc_lseek	= default_llseek,
 };
 
-static const struct file_operations proc_BSSList_ops = {
-	.owner		= THIS_MODULE,
-	.read		= proc_read,
-	.write		= proc_write,
-	.open		= proc_BSSList_open,
-	.release	= proc_close,
-	.llseek		= default_llseek,
+static const struct proc_ops proc_BSSList_ops = {
+	.proc_read	= proc_read,
+	.proc_write	= proc_write,
+	.proc_open	= proc_BSSList_open,
+	.proc_release	= proc_close,
+	.proc_lseek	= default_llseek,
 };
 
-static const struct file_operations proc_APList_ops = {
-	.owner		= THIS_MODULE,
-	.read		= proc_read,
-	.write		= proc_write,
-	.open		= proc_APList_open,
-	.release	= proc_close,
-	.llseek		= default_llseek,
+static const struct proc_ops proc_APList_ops = {
+	.proc_read	= proc_read,
+	.proc_write	= proc_write,
+	.proc_open	= proc_APList_open,
+	.proc_release	= proc_close,
+	.proc_lseek	= default_llseek,
 };
 
-static const struct file_operations proc_config_ops = {
-	.owner		= THIS_MODULE,
-	.read		= proc_read,
-	.write		= proc_write,
-	.open		= proc_config_open,
-	.release	= proc_close,
-	.llseek		= default_llseek,
+static const struct proc_ops proc_config_ops = {
+	.proc_read	= proc_read,
+	.proc_write	= proc_write,
+	.proc_open	= proc_config_open,
+	.proc_release	= proc_close,
+	.proc_lseek	= default_llseek,
 };
 
-static const struct file_operations proc_wepkey_ops = {
-	.owner		= THIS_MODULE,
-	.read		= proc_read,
-	.write		= proc_write,
-	.open		= proc_wepkey_open,
-	.release	= proc_close,
-	.llseek		= default_llseek,
+static const struct proc_ops proc_wepkey_ops = {
+	.proc_read	= proc_read,
+	.proc_write	= proc_write,
+	.proc_open	= proc_wepkey_open,
+	.proc_release	= proc_close,
+	.proc_lseek	= default_llseek,
 };
 
 static struct proc_dir_entry *airo_entry;
--- a/drivers/net/wireless/intel/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_module.c
@@ -240,13 +240,12 @@ static ssize_t debug_level_proc_write(struct file *file,
 	return strnlen(buf, len);
 }
 
-static const struct file_operations debug_level_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= debug_level_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= debug_level_proc_write,
+static const struct proc_ops debug_level_proc_ops = {
+	.proc_open	= debug_level_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= debug_level_proc_write,
 };
 #endif				/* CONFIG_LIBIPW_DEBUG */
 
@@ -263,7 +262,7 @@ static int __init libipw_init(void)
 		return -EIO;
 	}
 	e = proc_create("debug_level", 0644, libipw_proc,
-			&debug_level_proc_fops);
+			&debug_level_proc_ops);
 	if (!e) {
 		remove_proc_entry(DRV_PROCNAME, init_net.proc_net);
 		libipw_proc = NULL;
--- a/drivers/net/wireless/intersil/hostap/hostap_hw.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_hw.c
@@ -126,7 +126,7 @@ static void prism2_check_sta_fw_version(local_info_t *local);
 
 #ifdef PRISM2_DOWNLOAD_SUPPORT
 /* hostap_download.c */
-static const struct file_operations prism2_download_aux_dump_proc_fops;
+static const struct proc_ops prism2_download_aux_dump_proc_ops;
 static u8 * prism2_read_pda(struct net_device *dev);
 static int prism2_download(local_info_t *local,
 			   struct prism2_download_param *param);
@@ -3094,7 +3094,7 @@ prism2_init_local_data(struct prism2_helper_functions *funcs, int card_idx,
 	local->func->reset_port = prism2_reset_port;
 	local->func->schedule_reset = prism2_schedule_reset;
 #ifdef PRISM2_DOWNLOAD_SUPPORT
-	local->func->read_aux_fops = &prism2_download_aux_dump_proc_fops;
+	local->func->read_aux_proc_ops = &prism2_download_aux_dump_proc_ops;
 	local->func->download = prism2_download;
 #endif /* PRISM2_DOWNLOAD_SUPPORT */
 	local->func->tx = prism2_tx_80211;
--- a/drivers/net/wireless/intersil/hostap/hostap_proc.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_proc.c
@@ -211,9 +211,9 @@ static ssize_t prism2_pda_proc_read(struct file *file, char __user *buf,
 	return count;
 }
 
-static const struct file_operations prism2_pda_proc_fops = {
-	.read		= prism2_pda_proc_read,
-	.llseek		= generic_file_llseek,
+static const struct proc_ops prism2_pda_proc_ops = {
+	.proc_read	= prism2_pda_proc_read,
+	.proc_lseek	= generic_file_llseek,
 };
 
 
@@ -223,8 +223,8 @@ static ssize_t prism2_aux_dump_proc_no_read(struct file *file, char __user *buf,
 	return 0;
 }
 
-static const struct file_operations prism2_aux_dump_proc_fops = {
-	.read		= prism2_aux_dump_proc_no_read,
+static const struct proc_ops prism2_aux_dump_proc_ops = {
+	.proc_read	= prism2_aux_dump_proc_no_read,
 };
 
 
@@ -379,9 +379,9 @@ void hostap_init_proc(local_info_t *local)
 	proc_create_seq_data("wds", 0, local->proc,
 			&prism2_wds_proc_seqops, local);
 	proc_create_data("pda", 0, local->proc,
-			 &prism2_pda_proc_fops, local);
+			 &prism2_pda_proc_ops, local);
 	proc_create_data("aux_dump", 0, local->proc,
-			 local->func->read_aux_fops ?: &prism2_aux_dump_proc_fops,
+			 local->func->read_aux_proc_ops ?: &prism2_aux_dump_proc_ops,
 			 local);
 	proc_create_seq_data("bss_list", 0, local->proc,
 			&prism2_bss_list_proc_seqops, local);
--- a/drivers/net/wireless/intersil/hostap/hostap_wlan.h
+++ b/drivers/net/wireless/intersil/hostap/hostap_wlan.h
@@ -599,7 +599,7 @@ struct prism2_helper_functions {
 			struct prism2_download_param *param);
 	int (*tx)(struct sk_buff *skb, struct net_device *dev);
 	int (*set_tim)(struct net_device *dev, int aid, int set);
-	const struct file_operations *read_aux_fops;
+	const struct proc_ops *read_aux_proc_ops;
 
 	int need_tx_headroom; /* number of bytes of headroom needed before
 			       * IEEE 802.11 header */
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2717,10 +2717,9 @@ static ssize_t ray_cs_essid_proc_write(struct file *file,
 	return count;
 }
 
-static const struct file_operations ray_cs_essid_proc_fops = {
-	.owner		= THIS_MODULE,
-	.write		= ray_cs_essid_proc_write,
-	.llseek		= noop_llseek,
+static const struct proc_ops ray_cs_essid_proc_ops = {
+	.proc_write	= ray_cs_essid_proc_write,
+	.proc_lseek	= noop_llseek,
 };
 
 static ssize_t int_proc_write(struct file *file, const char __user *buffer,
@@ -2751,10 +2750,9 @@ static ssize_t int_proc_write(struct file *file, const char __user *buffer,
 	return count;
 }
 
-static const struct file_operations int_proc_fops = {
-	.owner		= THIS_MODULE,
-	.write		= int_proc_write,
-	.llseek		= noop_llseek,
+static const struct proc_ops int_proc_ops = {
+	.proc_write	= int_proc_write,
+	.proc_lseek	= noop_llseek,
 };
 #endif
 
@@ -2790,10 +2788,10 @@ static int __init init_ray_cs(void)
 	proc_mkdir("driver/ray_cs", NULL);
 
 	proc_create_single("driver/ray_cs/ray_cs", 0, NULL, ray_cs_proc_show);
-	proc_create("driver/ray_cs/essid", 0200, NULL, &ray_cs_essid_proc_fops);
-	proc_create_data("driver/ray_cs/net_type", 0200, NULL, &int_proc_fops,
+	proc_create("driver/ray_cs/essid", 0200, NULL, &ray_cs_essid_proc_ops);
+	proc_create_data("driver/ray_cs/net_type", 0200, NULL, &int_proc_ops,
 			 &net_type);
-	proc_create_data("driver/ray_cs/translate", 0200, NULL, &int_proc_fops,
+	proc_create_data("driver/ray_cs/translate", 0200, NULL, &int_proc_ops,
 			 &translate);
 #endif
 	if (translate != 0)
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -230,13 +230,12 @@ static ssize_t led_proc_write(struct file *file, const char __user *buf,
 	return -EINVAL;
 }
 
-static const struct file_operations led_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= led_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= led_proc_write,
+static const struct proc_ops led_proc_ops = {
+	.proc_open	= led_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= led_proc_write,
 };
 
 static int __init led_create_procfs(void)
@@ -252,14 +251,14 @@ static int __init led_create_procfs(void)
 	if (!lcd_no_led_support)
 	{
 		ent = proc_create_data("led", S_IRUGO|S_IWUSR, proc_pdc_root,
-					&led_proc_fops, (void *)LED_NOLCD); /* LED */
+					&led_proc_ops, (void *)LED_NOLCD); /* LED */
 		if (!ent) return -1;
 	}
 
 	if (led_type == LED_HASLCD)
 	{
 		ent = proc_create_data("lcd", S_IRUGO|S_IWUSR, proc_pdc_root,
-					&led_proc_fops, (void *)LED_HASLCD); /* LCD */
+					&led_proc_ops, (void *)LED_HASLCD); /* LCD */
 		if (!ent) return -1;
 	}
 
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -306,19 +306,20 @@ static int proc_bus_pci_release(struct inode *inode, struct file *file)
 }
 #endif /* HAVE_PCI_MMAP */
 
-static const struct file_operations proc_bus_pci_operations = {
-	.owner		= THIS_MODULE,
-	.llseek		= proc_bus_pci_lseek,
-	.read		= proc_bus_pci_read,
-	.write		= proc_bus_pci_write,
-	.unlocked_ioctl	= proc_bus_pci_ioctl,
-	.compat_ioctl	= proc_bus_pci_ioctl,
+static const struct proc_ops proc_bus_pci_ops = {
+	.proc_lseek	= proc_bus_pci_lseek,
+	.proc_read	= proc_bus_pci_read,
+	.proc_write	= proc_bus_pci_write,
+	.proc_ioctl	= proc_bus_pci_ioctl,
+#ifdef CONFIG_COMPAT
+	.proc_compat_ioctl = proc_bus_pci_ioctl,
+#endif
 #ifdef HAVE_PCI_MMAP
-	.open		= proc_bus_pci_open,
-	.release	= proc_bus_pci_release,
-	.mmap		= proc_bus_pci_mmap,
+	.proc_open	= proc_bus_pci_open,
+	.proc_release	= proc_bus_pci_release,
+	.proc_mmap	= proc_bus_pci_mmap,
 #ifdef HAVE_ARCH_PCI_GET_UNMAPPED_AREA
-	.get_unmapped_area = get_pci_unmapped_area,
+	.proc_get_unmapped_area = get_pci_unmapped_area,
 #endif /* HAVE_ARCH_PCI_GET_UNMAPPED_AREA */
 #endif /* HAVE_PCI_MMAP */
 };
@@ -424,7 +425,7 @@ int pci_proc_attach_device(struct pci_dev *dev)
 
 	sprintf(name, "%02x.%x", PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn));
 	e = proc_create_data(name, S_IFREG | S_IRUGO | S_IWUSR, bus->procdir,
-			     &proc_bus_pci_operations, dev);
+			     &proc_bus_pci_ops, dev);
 	if (!e)
 		return -ENOMEM;
 	proc_set_size(e, dev->cfg_size);
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -907,13 +907,12 @@ static ssize_t dispatch_proc_write(struct file *file,
 	return ret;
 }
 
-static const struct file_operations dispatch_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= dispatch_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= dispatch_proc_write,
+static const struct proc_ops dispatch_proc_ops = {
+	.proc_open	= dispatch_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= dispatch_proc_write,
 };
 
 static char *next_cmd(char **cmds)
@@ -9984,7 +9983,7 @@ static int __init ibm_init(struct ibm_init_struct *iibm)
 		if (ibm->write)
 			mode |= S_IWUSR;
 		entry = proc_create_data(ibm->name, mode, proc_dir,
-					 &dispatch_proc_fops, ibm);
+					 &dispatch_proc_ops, ibm);
 		if (!entry) {
 			pr_err("unable to create proc entry %s\n", ibm->name);
 			ret = -ENODEV;
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1432,13 +1432,12 @@ static ssize_t lcd_proc_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static const struct file_operations lcd_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= lcd_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= lcd_proc_write,
+static const struct proc_ops lcd_proc_ops = {
+	.proc_open	= lcd_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= lcd_proc_write,
 };
 
 /* Video-Out */
@@ -1539,13 +1538,12 @@ static ssize_t video_proc_write(struct file *file, const char __user *buf,
 	return ret ? -EIO : count;
 }
 
-static const struct file_operations video_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= video_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= video_proc_write,
+static const struct proc_ops video_proc_ops = {
+	.proc_open	= video_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= video_proc_write,
 };
 
 /* Fan status */
@@ -1617,13 +1615,12 @@ static ssize_t fan_proc_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static const struct file_operations fan_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= fan_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= fan_proc_write,
+static const struct proc_ops fan_proc_ops = {
+	.proc_open	= fan_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= fan_proc_write,
 };
 
 static int keys_proc_show(struct seq_file *m, void *v)
@@ -1662,13 +1659,12 @@ static ssize_t keys_proc_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static const struct file_operations keys_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= keys_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= keys_proc_write,
+static const struct proc_ops keys_proc_ops = {
+	.proc_open	= keys_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= keys_proc_write,
 };
 
 static int __maybe_unused version_proc_show(struct seq_file *m, void *v)
@@ -1688,16 +1684,16 @@ static void create_toshiba_proc_entries(struct toshiba_acpi_dev *dev)
 {
 	if (dev->backlight_dev)
 		proc_create_data("lcd", S_IRUGO | S_IWUSR, toshiba_proc_dir,
-				 &lcd_proc_fops, dev);
+				 &lcd_proc_ops, dev);
 	if (dev->video_supported)
 		proc_create_data("video", S_IRUGO | S_IWUSR, toshiba_proc_dir,
-				 &video_proc_fops, dev);
+				 &video_proc_ops, dev);
 	if (dev->fan_supported)
 		proc_create_data("fan", S_IRUGO | S_IWUSR, toshiba_proc_dir,
-				 &fan_proc_fops, dev);
+				 &fan_proc_ops, dev);
 	if (dev->hotkey_dev)
 		proc_create_data("keys", S_IRUGO | S_IWUSR, toshiba_proc_dir,
-				 &keys_proc_fops, dev);
+				 &keys_proc_ops, dev);
 	proc_create_single_data("version", S_IRUGO, toshiba_proc_dir,
 			version_proc_show, dev);
 }
--- a/drivers/pnp/isapnp/proc.c
+++ b/drivers/pnp/isapnp/proc.c
@@ -49,10 +49,9 @@ static ssize_t isapnp_proc_bus_read(struct file *file, char __user * buf,
 	return nbytes;
 }
 
-static const struct file_operations isapnp_proc_bus_file_operations = {
-	.owner	= THIS_MODULE,
-	.llseek = isapnp_proc_bus_lseek,
-	.read = isapnp_proc_bus_read,
+static const struct proc_ops isapnp_proc_bus_proc_ops = {
+	.proc_lseek	= isapnp_proc_bus_lseek,
+	.proc_read	= isapnp_proc_bus_read,
 };
 
 static int isapnp_proc_attach_device(struct pnp_dev *dev)
@@ -69,7 +68,7 @@ static int isapnp_proc_attach_device(struct pnp_dev *dev)
 	}
 	sprintf(name, "%02x", dev->number);
 	e = dev->procent = proc_create_data(name, S_IFREG | S_IRUGO, de,
-			&isapnp_proc_bus_file_operations, dev);
+					    &isapnp_proc_bus_proc_ops, dev);
 	if (!e)
 		return -ENOMEM;
 	proc_set_size(e, 256);
--- a/drivers/pnp/pnpbios/proc.c
+++ b/drivers/pnp/pnpbios/proc.c
@@ -210,13 +210,12 @@ static ssize_t pnpbios_proc_write(struct file *file, const char __user *buf,
 	return ret;
 }
 
-static const struct file_operations pnpbios_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= pnpbios_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= pnpbios_proc_write,
+static const struct proc_ops pnpbios_proc_ops = {
+	.proc_open	= pnpbios_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= pnpbios_proc_write,
 };
 
 int pnpbios_interface_attach_device(struct pnp_bios_node *node)
@@ -228,13 +227,13 @@ int pnpbios_interface_attach_device(struct pnp_bios_node *node)
 	if (!proc_pnp)
 		return -EIO;
 	if (!pnpbios_dont_use_current_config) {
-		proc_create_data(name, 0644, proc_pnp, &pnpbios_proc_fops,
+		proc_create_data(name, 0644, proc_pnp, &pnpbios_proc_ops,
 				 (void *)(long)(node->handle));
 	}
 
 	if (!proc_pnp_boot)
 		return -EIO;
-	if (proc_create_data(name, 0644, proc_pnp_boot, &pnpbios_proc_fops,
+	if (proc_create_data(name, 0644, proc_pnp_boot, &pnpbios_proc_ops,
 			     (void *)(long)(node->handle + 0x100)))
 		return 0;
 	return -EIO;
--- a/drivers/s390/block/dasd_proc.c
+++ b/drivers/s390/block/dasd_proc.c
@@ -320,13 +320,12 @@ static ssize_t dasd_stats_proc_write(struct file *file,
 #endif				/* CONFIG_DASD_PROFILE */
 }
 
-static const struct file_operations dasd_stats_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= dasd_stats_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= dasd_stats_proc_write,
+static const struct proc_ops dasd_stats_proc_ops = {
+	.proc_open	= dasd_stats_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= dasd_stats_proc_write,
 };
 
 /*
@@ -347,7 +346,7 @@ dasd_proc_init(void)
 	dasd_statistics_entry = proc_create("statistics",
 					    S_IFREG | S_IRUGO | S_IWUSR,
 					    dasd_proc_root_entry,
-					    &dasd_stats_proc_fops);
+					    &dasd_stats_proc_ops);
 	if (!dasd_statistics_entry)
 		goto out_nostatistics;
 	return 0;
--- a/drivers/s390/cio/blacklist.c
+++ b/drivers/s390/cio/blacklist.c
@@ -398,12 +398,12 @@ cio_ignore_proc_open(struct inode *inode, struct file *file)
 				sizeof(struct ccwdev_iter));
 }
 
-static const struct file_operations cio_ignore_proc_fops = {
-	.open    = cio_ignore_proc_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_private,
-	.write   = cio_ignore_write,
+static const struct proc_ops cio_ignore_proc_ops = {
+	.proc_open	= cio_ignore_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release_private,
+	.proc_write	= cio_ignore_write,
 };
 
 static int
@@ -412,7 +412,7 @@ cio_ignore_proc_init (void)
 	struct proc_dir_entry *entry;
 
 	entry = proc_create("cio_ignore", S_IFREG | S_IRUGO | S_IWUSR, NULL,
-			    &cio_ignore_proc_fops);
+			    &cio_ignore_proc_ops);
 	if (!entry)
 		return -ENOENT;
 	return 0;
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -1372,18 +1372,17 @@ static ssize_t cio_settle_write(struct file *file, const char __user *buf,
 	return ret ? ret : count;
 }
 
-static const struct file_operations cio_settle_proc_fops = {
-	.open = nonseekable_open,
-	.write = cio_settle_write,
-	.llseek = no_llseek,
+static const struct proc_ops cio_settle_proc_ops = {
+	.proc_open	= nonseekable_open,
+	.proc_write	= cio_settle_write,
+	.proc_lseek	= no_llseek,
 };
 
 static int __init cio_settle_init(void)
 {
 	struct proc_dir_entry *entry;
 
-	entry = proc_create("cio_settle", S_IWUSR, NULL,
-			    &cio_settle_proc_fops);
+	entry = proc_create("cio_settle", S_IWUSR, NULL, &cio_settle_proc_ops);
 	if (!entry)
 		return -ENOMEM;
 	return 0;
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -617,6 +617,13 @@ static const struct file_operations esas2r_proc_fops = {
 	.unlocked_ioctl = esas2r_proc_ioctl,
 };
 
+static const struct proc_ops esas2r_proc_ops = {
+	.proc_ioctl		= esas2r_proc_ioctl,
+#ifdef CONFIG_COMPAT
+	.proc_compat_ioctl	= compat_ptr_ioctl,
+#endif
+};
+
 static struct Scsi_Host *esas2r_proc_host;
 static int esas2r_proc_major;
 
@@ -728,7 +735,7 @@ const char *esas2r_info(struct Scsi_Host *sh)
 
 			pde = proc_create(ATTONODE_NAME, 0,
 					  sh->hostt->proc_dir,
-					  &esas2r_proc_fops);
+					  &esas2r_proc_ops);
 
 			if (!pde) {
 				esas2r_log_dev(ESAS2R_LOG_WARN,
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -736,13 +736,12 @@ static ssize_t proc_scsi_devinfo_write(struct file *file,
 	return err;
 }
 
-static const struct file_operations scsi_devinfo_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= proc_scsi_devinfo_open,
-	.read		= seq_read,
-	.write		= proc_scsi_devinfo_write,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
+static const struct proc_ops scsi_devinfo_proc_ops = {
+	.proc_open	= proc_scsi_devinfo_open,
+	.proc_read	= seq_read,
+	.proc_write	= proc_scsi_devinfo_write,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release,
 };
 #endif /* CONFIG_SCSI_PROC_FS */
 
@@ -867,7 +866,7 @@ int __init scsi_init_devinfo(void)
 	}
 
 #ifdef CONFIG_SCSI_PROC_FS
-	p = proc_create("scsi/device_info", 0, NULL, &scsi_devinfo_proc_fops);
+	p = proc_create("scsi/device_info", 0, NULL, &scsi_devinfo_proc_ops);
 	if (!p) {
 		error = -ENOMEM;
 		goto out;
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -83,12 +83,12 @@ static int proc_scsi_host_open(struct inode *inode, struct file *file)
 				4 * PAGE_SIZE);
 }
 
-static const struct file_operations proc_scsi_fops = {
-	.open = proc_scsi_host_open,
-	.release = single_release,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.write = proc_scsi_host_write
+static const struct proc_ops proc_scsi_ops = {
+	.proc_open	= proc_scsi_host_open,
+	.proc_release	= single_release,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= proc_scsi_host_write
 };
 
 /**
@@ -146,7 +146,7 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
 
 	sprintf(name,"%d", shost->host_no);
 	p = proc_create_data(name, S_IRUGO | S_IWUSR,
-		sht->proc_dir, &proc_scsi_fops, shost);
+		sht->proc_dir, &proc_scsi_ops, shost);
 	if (!p)
 		printk(KERN_ERR "%s: Failed to register host %d in"
 		       "%s\n", __func__, shost->host_no,
@@ -436,13 +436,12 @@ static int proc_scsi_open(struct inode *inode, struct file *file)
 	return seq_open(file, &scsi_seq_ops);
 }
 
-static const struct file_operations proc_scsi_operations = {
-	.owner		= THIS_MODULE,
-	.open		= proc_scsi_open,
-	.read		= seq_read,
-	.write		= proc_scsi_write,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
+static const struct proc_ops scsi_scsi_proc_ops = {
+	.proc_open	= proc_scsi_open,
+	.proc_read	= seq_read,
+	.proc_write	= proc_scsi_write,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release,
 };
 
 /**
@@ -456,7 +455,7 @@ int __init scsi_init_procfs(void)
 	if (!proc_scsi)
 		goto err1;
 
-	pde = proc_create("scsi/scsi", 0, NULL, &proc_scsi_operations);
+	pde = proc_create("scsi/scsi", 0, NULL, &scsi_scsi_proc_ops);
 	if (!pde)
 		goto err2;
 
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2320,25 +2320,23 @@ static int sg_proc_seq_show_int(struct seq_file *s, void *v);
 static int sg_proc_single_open_adio(struct inode *inode, struct file *file);
 static ssize_t sg_proc_write_adio(struct file *filp, const char __user *buffer,
 			          size_t count, loff_t *off);
-static const struct file_operations adio_fops = {
-	.owner = THIS_MODULE,
-	.open = sg_proc_single_open_adio,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.write = sg_proc_write_adio,
-	.release = single_release,
+static const struct proc_ops adio_proc_ops = {
+	.proc_open	= sg_proc_single_open_adio,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= sg_proc_write_adio,
+	.proc_release	= single_release,
 };
 
 static int sg_proc_single_open_dressz(struct inode *inode, struct file *file);
 static ssize_t sg_proc_write_dressz(struct file *filp, 
 		const char __user *buffer, size_t count, loff_t *off);
-static const struct file_operations dressz_fops = {
-	.owner = THIS_MODULE,
-	.open = sg_proc_single_open_dressz,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.write = sg_proc_write_dressz,
-	.release = single_release,
+static const struct proc_ops dressz_proc_ops = {
+	.proc_open	= sg_proc_single_open_dressz,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= sg_proc_write_dressz,
+	.proc_release	= single_release,
 };
 
 static int sg_proc_seq_show_version(struct seq_file *s, void *v);
@@ -2379,9 +2377,9 @@ sg_proc_init(void)
 	if (!p)
 		return 1;
 
-	proc_create("allow_dio", S_IRUGO | S_IWUSR, p, &adio_fops);
+	proc_create("allow_dio", S_IRUGO | S_IWUSR, p, &adio_proc_ops);
 	proc_create_seq("debug", S_IRUGO, p, &debug_seq_ops);
-	proc_create("def_reserved_size", S_IRUGO | S_IWUSR, p, &dressz_fops);
+	proc_create("def_reserved_size", S_IRUGO | S_IWUSR, p, &dressz_proc_ops);
 	proc_create_single("device_hdr", S_IRUGO, p, sg_proc_seq_show_devhdr);
 	proc_create_seq("devices", S_IRUGO, p, &dev_seq_ops);
 	proc_create_seq("device_strs", S_IRUGO, p, &devstrs_seq_ops);
--- a/drivers/staging/isdn/hysdn/hysdn_procconf.c
+++ b/drivers/staging/isdn/hysdn/hysdn_procconf.c
@@ -336,14 +336,13 @@ hysdn_conf_close(struct inode *ino, struct file *filep)
 /******************************************************/
 /* table for conf filesystem functions defined above. */
 /******************************************************/
-static const struct file_operations conf_fops =
+static const struct proc_ops conf_proc_ops =
 {
-	.owner		= THIS_MODULE,
-	.llseek         = no_llseek,
-	.read           = hysdn_conf_read,
-	.write          = hysdn_conf_write,
-	.open           = hysdn_conf_open,
-	.release        = hysdn_conf_close,
+	.proc_lseek	= no_llseek,
+	.proc_read	= hysdn_conf_read,
+	.proc_write	= hysdn_conf_write,
+	.proc_open	= hysdn_conf_open,
+	.proc_release	= hysdn_conf_close,
 };
 
 /*****************************/
@@ -374,7 +373,7 @@ hysdn_procconf_init(void)
 		if ((card->procconf = (void *) proc_create_data(conf_name,
 							   S_IFREG | S_IRUGO | S_IWUSR,
 							   hysdn_proc_entry,
-							   &conf_fops,
+							   &conf_proc_ops,
 							   card)) != NULL) {
 			hysdn_proclog_init(card);	/* init the log file entry */
 		}
--- a/drivers/staging/isdn/hysdn/hysdn_proclog.c
+++ b/drivers/staging/isdn/hysdn/hysdn_proclog.c
@@ -302,15 +302,14 @@ hysdn_log_poll(struct file *file, poll_table *wait)
 /**************************************************/
 /* table for log filesystem functions defined above. */
 /**************************************************/
-static const struct file_operations log_fops =
+static const struct proc_ops log_proc_ops =
 {
-	.owner		= THIS_MODULE,
-	.llseek         = no_llseek,
-	.read           = hysdn_log_read,
-	.write          = hysdn_log_write,
-	.poll           = hysdn_log_poll,
-	.open           = hysdn_log_open,
-	.release        = hysdn_log_close,
+	.proc_lseek	= no_llseek,
+	.proc_read	= hysdn_log_read,
+	.proc_write	= hysdn_log_write,
+	.proc_poll	= hysdn_log_poll,
+	.proc_open	= hysdn_log_open,
+	.proc_release	= hysdn_log_close,
 };
 
 
@@ -329,7 +328,7 @@ hysdn_proclog_init(hysdn_card *card)
 		sprintf(pd->log_name, "%s%d", PROC_LOG_BASENAME, card->myid);
 		pd->log = proc_create_data(pd->log_name,
 				      S_IFREG | S_IRUGO | S_IWUSR, hysdn_proc_entry,
-				      &log_fops, card);
+				      &log_proc_ops, card);
 
 		init_waitqueue_head(&(pd->rd_queue));
 
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
@@ -264,12 +264,12 @@ static int open_debug_level(struct inode *inode, struct file *file)
 	return single_open(file, show_debug_level, NULL);
 }
 
-static const struct file_operations fops = {
-	.open = open_debug_level,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.write = write_debug_level,
-	.release = single_release,
+static const struct proc_ops debug_level_proc_ops = {
+	.proc_open	= open_debug_level,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= write_debug_level,
+	.proc_release	= single_release,
 };
 
 int __init ieee80211_debug_init(void)
@@ -284,7 +284,7 @@ int __init ieee80211_debug_init(void)
 				" proc directory\n");
 		return -EIO;
 	}
-	e = proc_create("debug_level", 0644, ieee80211_proc, &fops);
+	e = proc_create("debug_level", 0644, ieee80211_proc, &debug_level_proc_ops);
 	if (!e) {
 		remove_proc_entry(DRV_NAME, init_net.proc_net);
 		ieee80211_proc = NULL;
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -1108,15 +1108,15 @@ static ssize_t write_sysrq_trigger(struct file *file, const char __user *buf,
 	return count;
 }
 
-static const struct file_operations proc_sysrq_trigger_operations = {
-	.write		= write_sysrq_trigger,
-	.llseek		= noop_llseek,
+static const struct proc_ops sysrq_trigger_proc_ops = {
+	.proc_write	= write_sysrq_trigger,
+	.proc_lseek	= noop_llseek,
 };
 
 static void sysrq_init_procfs(void)
 {
 	if (!proc_create("sysrq-trigger", S_IWUSR, NULL,
-			 &proc_sysrq_trigger_operations))
+			 &sysrq_trigger_proc_ops))
 		pr_err("Failed to register proc interface\n");
 }
 
--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -72,7 +72,7 @@ static rndis_resp_t *rndis_add_response(struct rndis_params *params,
 
 #ifdef CONFIG_USB_GADGET_DEBUG_FILES
 
-static const struct file_operations rndis_proc_fops;
+static const struct proc_ops rndis_proc_ops;
 
 #endif /* CONFIG_USB_GADGET_DEBUG_FILES */
 
@@ -902,7 +902,7 @@ struct rndis_params *rndis_register(void (*resp_avail)(void *v), void *v)
 
 		sprintf(name, NAME_TEMPLATE, i);
 		proc_entry = proc_create_data(name, 0660, NULL,
-					      &rndis_proc_fops, params);
+					      &rndis_proc_ops, params);
 		if (!proc_entry) {
 			kfree(params);
 			rndis_put_nr(i);
@@ -1164,13 +1164,12 @@ static int rndis_proc_open(struct inode *inode, struct file *file)
 	return single_open(file, rndis_proc_show, PDE_DATA(inode));
 }
 
-static const struct file_operations rndis_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= rndis_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= rndis_proc_write,
+static const struct proc_ops rndis_proc_ops = {
+	.proc_open	= rndis_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= rndis_proc_write,
 };
 
 #define	NAME_TEMPLATE "driver/rndis-%03d"
--- a/drivers/video/fbdev/via/viafbdev.c
+++ b/drivers/video/fbdev/via/viafbdev.c
@@ -1173,13 +1173,12 @@ static ssize_t viafb_dvp0_proc_write(struct file *file,
 	return count;
 }
 
-static const struct file_operations viafb_dvp0_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= viafb_dvp0_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= viafb_dvp0_proc_write,
+static const struct proc_ops viafb_dvp0_proc_ops = {
+	.proc_open	= viafb_dvp0_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= viafb_dvp0_proc_write,
 };
 
 static int viafb_dvp1_proc_show(struct seq_file *m, void *v)
@@ -1238,13 +1237,12 @@ static ssize_t viafb_dvp1_proc_write(struct file *file,
 	return count;
 }
 
-static const struct file_operations viafb_dvp1_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= viafb_dvp1_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= viafb_dvp1_proc_write,
+static const struct proc_ops viafb_dvp1_proc_ops = {
+	.proc_open	= viafb_dvp1_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= viafb_dvp1_proc_write,
 };
 
 static int viafb_dfph_proc_show(struct seq_file *m, void *v)
@@ -1273,13 +1271,12 @@ static ssize_t viafb_dfph_proc_write(struct file *file,
 	return count;
 }
 
-static const struct file_operations viafb_dfph_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= viafb_dfph_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= viafb_dfph_proc_write,
+static const struct proc_ops viafb_dfph_proc_ops = {
+	.proc_open	= viafb_dfph_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= viafb_dfph_proc_write,
 };
 
 static int viafb_dfpl_proc_show(struct seq_file *m, void *v)
@@ -1308,13 +1305,12 @@ static ssize_t viafb_dfpl_proc_write(struct file *file,
 	return count;
 }
 
-static const struct file_operations viafb_dfpl_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= viafb_dfpl_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= viafb_dfpl_proc_write,
+static const struct proc_ops viafb_dfpl_proc_ops = {
+	.proc_open	= viafb_dfpl_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= viafb_dfpl_proc_write,
 };
 
 static int viafb_vt1636_proc_show(struct seq_file *m, void *v)
@@ -1444,13 +1440,12 @@ static ssize_t viafb_vt1636_proc_write(struct file *file,
 	return count;
 }
 
-static const struct file_operations viafb_vt1636_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= viafb_vt1636_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= viafb_vt1636_proc_write,
+static const struct proc_ops viafb_vt1636_proc_ops = {
+	.proc_open	= viafb_vt1636_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= viafb_vt1636_proc_write,
 };
 
 #endif /* CONFIG_FB_VIA_DIRECT_PROCFS */
@@ -1522,13 +1517,12 @@ static ssize_t viafb_iga1_odev_proc_write(struct file *file,
 	return res;
 }
 
-static const struct file_operations viafb_iga1_odev_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= viafb_iga1_odev_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= viafb_iga1_odev_proc_write,
+static const struct proc_ops viafb_iga1_odev_proc_ops = {
+	.proc_open	= viafb_iga1_odev_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= viafb_iga1_odev_proc_write,
 };
 
 static int viafb_iga2_odev_proc_show(struct seq_file *m, void *v)
@@ -1562,13 +1556,12 @@ static ssize_t viafb_iga2_odev_proc_write(struct file *file,
 	return res;
 }
 
-static const struct file_operations viafb_iga2_odev_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= viafb_iga2_odev_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= viafb_iga2_odev_proc_write,
+static const struct proc_ops viafb_iga2_odev_proc_ops = {
+	.proc_open	= viafb_iga2_odev_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= viafb_iga2_odev_proc_write,
 };
 
 #define IS_VT1636(lvds_chip)	((lvds_chip).lvds_chip_name == VT1636_LVDS)
@@ -1580,14 +1573,14 @@ static void viafb_init_proc(struct viafb_shared *shared)
 	shared->proc_entry = viafb_entry;
 	if (viafb_entry) {
 #ifdef CONFIG_FB_VIA_DIRECT_PROCFS
-		proc_create("dvp0", 0, viafb_entry, &viafb_dvp0_proc_fops);
-		proc_create("dvp1", 0, viafb_entry, &viafb_dvp1_proc_fops);
-		proc_create("dfph", 0, viafb_entry, &viafb_dfph_proc_fops);
-		proc_create("dfpl", 0, viafb_entry, &viafb_dfpl_proc_fops);
+		proc_create("dvp0", 0, viafb_entry, &viafb_dvp0_proc_ops);
+		proc_create("dvp1", 0, viafb_entry, &viafb_dvp1_proc_ops);
+		proc_create("dfph", 0, viafb_entry, &viafb_dfph_proc_ops);
+		proc_create("dfpl", 0, viafb_entry, &viafb_dfpl_proc_ops);
 		if (IS_VT1636(shared->chip_info.lvds_chip_info)
 			|| IS_VT1636(shared->chip_info.lvds_chip_info2))
 			proc_create("vt1636", 0, viafb_entry,
-				&viafb_vt1636_proc_fops);
+				    &viafb_vt1636_proc_ops);
 #endif /* CONFIG_FB_VIA_DIRECT_PROCFS */
 
 		proc_create_single("supported_output_devices", 0, viafb_entry,
@@ -1595,11 +1588,11 @@ static void viafb_init_proc(struct viafb_shared *shared)
 		iga1_entry = proc_mkdir("iga1", viafb_entry);
 		shared->iga1_proc_entry = iga1_entry;
 		proc_create("output_devices", 0, iga1_entry,
-			&viafb_iga1_odev_proc_fops);
+			    &viafb_iga1_odev_proc_ops);
 		iga2_entry = proc_mkdir("iga2", viafb_entry);
 		shared->iga2_proc_entry = iga2_entry;
 		proc_create("output_devices", 0, iga2_entry,
-			&viafb_iga2_odev_proc_fops);
+			    &viafb_iga2_odev_proc_ops);
 	}
 }
 static void viafb_remove_proc(struct viafb_shared *shared)
--- a/drivers/zorro/proc.c
+++ b/drivers/zorro/proc.c
@@ -56,10 +56,9 @@ proc_bus_zorro_read(struct file *file, char __user *buf, size_t nbytes, loff_t *
 	return nbytes;
 }
 
-static const struct file_operations proc_bus_zorro_operations = {
-	.owner		= THIS_MODULE,
-	.llseek		= proc_bus_zorro_lseek,
-	.read		= proc_bus_zorro_read,
+static const struct proc_ops bus_zorro_proc_ops = {
+	.proc_lseek	= proc_bus_zorro_lseek,
+	.proc_read	= proc_bus_zorro_read,
 };
 
 static void * zorro_seq_start(struct seq_file *m, loff_t *pos)
@@ -105,7 +104,7 @@ static int __init zorro_proc_attach_device(unsigned int slot)
 
 	sprintf(name, "%02x", slot);
 	entry = proc_create_data(name, 0, proc_bus_zorro_dir,
-				 &proc_bus_zorro_operations,
+				 &bus_zorro_proc_ops,
 				 &zorro_autocon[slot]);
 	if (!entry)
 		return -ENOMEM;
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -611,12 +611,12 @@ static int cifs_stats_proc_open(struct inode *inode, struct file *file)
 	return single_open(file, cifs_stats_proc_show, NULL);
 }
 
-static const struct file_operations cifs_stats_proc_fops = {
-	.open		= cifs_stats_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= cifs_stats_proc_write,
+static const struct proc_ops cifs_stats_proc_ops = {
+	.proc_open	= cifs_stats_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= cifs_stats_proc_write,
 };
 
 #ifdef CONFIG_CIFS_SMB_DIRECT
@@ -640,12 +640,12 @@ static int name##_open(struct inode *inode, struct file *file) \
 	return single_open(file, name##_proc_show, NULL); \
 } \
 \
-static const struct file_operations cifs_##name##_proc_fops = { \
-	.open		= name##_open, \
-	.read		= seq_read, \
-	.llseek		= seq_lseek, \
-	.release	= single_release, \
-	.write		= name##_write, \
+static const struct proc_ops cifs_##name##_proc_fops = { \
+	.proc_open	= name##_open, \
+	.proc_read	= seq_read, \
+	.proc_lseek	= seq_lseek, \
+	.proc_release	= single_release, \
+	.proc_write	= name##_write, \
 }
 
 PROC_FILE_DEFINE(rdma_readwrite_threshold);
@@ -659,11 +659,11 @@ PROC_FILE_DEFINE(smbd_receive_credit_max);
 #endif
 
 static struct proc_dir_entry *proc_fs_cifs;
-static const struct file_operations cifsFYI_proc_fops;
-static const struct file_operations cifs_lookup_cache_proc_fops;
-static const struct file_operations traceSMB_proc_fops;
-static const struct file_operations cifs_security_flags_proc_fops;
-static const struct file_operations cifs_linux_ext_proc_fops;
+static const struct proc_ops cifsFYI_proc_ops;
+static const struct proc_ops cifs_lookup_cache_proc_ops;
+static const struct proc_ops traceSMB_proc_ops;
+static const struct proc_ops cifs_security_flags_proc_ops;
+static const struct proc_ops cifs_linux_ext_proc_ops;
 
 void
 cifs_proc_init(void)
@@ -678,18 +678,18 @@ cifs_proc_init(void)
 	proc_create_single("open_files", 0400, proc_fs_cifs,
 			cifs_debug_files_proc_show);
 
-	proc_create("Stats", 0644, proc_fs_cifs, &cifs_stats_proc_fops);
-	proc_create("cifsFYI", 0644, proc_fs_cifs, &cifsFYI_proc_fops);
-	proc_create("traceSMB", 0644, proc_fs_cifs, &traceSMB_proc_fops);
+	proc_create("Stats", 0644, proc_fs_cifs, &cifs_stats_proc_ops);
+	proc_create("cifsFYI", 0644, proc_fs_cifs, &cifsFYI_proc_ops);
+	proc_create("traceSMB", 0644, proc_fs_cifs, &traceSMB_proc_ops);
 	proc_create("LinuxExtensionsEnabled", 0644, proc_fs_cifs,
-		    &cifs_linux_ext_proc_fops);
+		    &cifs_linux_ext_proc_ops);
 	proc_create("SecurityFlags", 0644, proc_fs_cifs,
-		    &cifs_security_flags_proc_fops);
+		    &cifs_security_flags_proc_ops);
 	proc_create("LookupCacheEnabled", 0644, proc_fs_cifs,
-		    &cifs_lookup_cache_proc_fops);
+		    &cifs_lookup_cache_proc_ops);
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
-	proc_create("dfscache", 0644, proc_fs_cifs, &dfscache_proc_fops);
+	proc_create("dfscache", 0644, proc_fs_cifs, &dfscache_proc_ops);
 #endif
 
 #ifdef CONFIG_CIFS_SMB_DIRECT
@@ -774,12 +774,12 @@ static ssize_t cifsFYI_proc_write(struct file *file, const char __user *buffer,
 	return count;
 }
 
-static const struct file_operations cifsFYI_proc_fops = {
-	.open		= cifsFYI_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= cifsFYI_proc_write,
+static const struct proc_ops cifsFYI_proc_ops = {
+	.proc_open	= cifsFYI_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= cifsFYI_proc_write,
 };
 
 static int cifs_linux_ext_proc_show(struct seq_file *m, void *v)
@@ -805,12 +805,12 @@ static ssize_t cifs_linux_ext_proc_write(struct file *file,
 	return count;
 }
 
-static const struct file_operations cifs_linux_ext_proc_fops = {
-	.open		= cifs_linux_ext_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= cifs_linux_ext_proc_write,
+static const struct proc_ops cifs_linux_ext_proc_ops = {
+	.proc_open	= cifs_linux_ext_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= cifs_linux_ext_proc_write,
 };
 
 static int cifs_lookup_cache_proc_show(struct seq_file *m, void *v)
@@ -836,12 +836,12 @@ static ssize_t cifs_lookup_cache_proc_write(struct file *file,
 	return count;
 }
 
-static const struct file_operations cifs_lookup_cache_proc_fops = {
-	.open		= cifs_lookup_cache_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= cifs_lookup_cache_proc_write,
+static const struct proc_ops cifs_lookup_cache_proc_ops = {
+	.proc_open	= cifs_lookup_cache_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= cifs_lookup_cache_proc_write,
 };
 
 static int traceSMB_proc_show(struct seq_file *m, void *v)
@@ -867,12 +867,12 @@ static ssize_t traceSMB_proc_write(struct file *file, const char __user *buffer,
 	return count;
 }
 
-static const struct file_operations traceSMB_proc_fops = {
-	.open		= traceSMB_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= traceSMB_proc_write,
+static const struct proc_ops traceSMB_proc_ops = {
+	.proc_open	= traceSMB_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= traceSMB_proc_write,
 };
 
 static int cifs_security_flags_proc_show(struct seq_file *m, void *v)
@@ -978,12 +978,12 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 	return count;
 }
 
-static const struct file_operations cifs_security_flags_proc_fops = {
-	.open		= cifs_security_flags_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= cifs_security_flags_proc_write,
+static const struct proc_ops cifs_security_flags_proc_ops = {
+	.proc_open	= cifs_security_flags_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= cifs_security_flags_proc_write,
 };
 #else
 inline void cifs_proc_init(void)
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2018-2019 Paulo Alcantara <palcantara@suse.de>
  */
 
+#include <linux/proc_fs.h>
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
 #include <linux/jhash.h>
@@ -217,12 +218,12 @@ static int dfscache_proc_open(struct inode *inode, struct file *file)
 	return single_open(file, dfscache_proc_show, NULL);
 }
 
-const struct file_operations dfscache_proc_fops = {
-	.open		= dfscache_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= dfscache_proc_write,
+const struct proc_ops dfscache_proc_ops = {
+	.proc_open	= dfscache_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= dfscache_proc_write,
 };
 
 #ifdef CONFIG_CIFS_DEBUG2
--- a/fs/cifs/dfs_cache.h
+++ b/fs/cifs/dfs_cache.h
@@ -24,7 +24,7 @@ struct dfs_cache_tgt_iterator {
 
 extern int dfs_cache_init(void);
 extern void dfs_cache_destroy(void);
-extern const struct file_operations dfscache_proc_fops;
+extern const struct proc_ops dfscache_proc_ops;
 
 extern int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses,
 			  const struct nls_table *nls_codepage, int remap,
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -111,7 +111,7 @@ extern void fscache_enqueue_object(struct fscache_object *);
  * object-list.c
  */
 #ifdef CONFIG_FSCACHE_OBJECT_LIST
-extern const struct file_operations fscache_objlist_fops;
+extern const struct proc_ops fscache_objlist_proc_ops;
 
 extern void fscache_objlist_add(struct fscache_object *);
 extern void fscache_objlist_remove(struct fscache_object *);
--- a/fs/fscache/object-list.c
+++ b/fs/fscache/object-list.c
@@ -7,6 +7,7 @@
 
 #define FSCACHE_DEBUG_LEVEL COOKIE
 #include <linux/module.h>
+#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/key.h>
@@ -405,9 +406,9 @@ static int fscache_objlist_release(struct inode *inode, struct file *file)
 	return seq_release(inode, file);
 }
 
-const struct file_operations fscache_objlist_fops = {
-	.open		= fscache_objlist_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= fscache_objlist_release,
+const struct proc_ops fscache_objlist_proc_ops = {
+	.proc_open	= fscache_objlist_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= fscache_objlist_release,
 };
--- a/fs/fscache/proc.c
+++ b/fs/fscache/proc.c
@@ -35,7 +35,7 @@ int __init fscache_proc_init(void)
 
 #ifdef CONFIG_FSCACHE_OBJECT_LIST
 	if (!proc_create("fs/fscache/objects", S_IFREG | 0444, NULL,
-			 &fscache_objlist_fops))
+			 &fscache_objlist_proc_ops))
 		goto error_objects;
 #endif
 
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1074,12 +1074,11 @@ static int jbd2_seq_info_release(struct inode *inode, struct file *file)
 	return seq_release(inode, file);
 }
 
-static const struct file_operations jbd2_seq_info_fops = {
-	.owner		= THIS_MODULE,
-	.open           = jbd2_seq_info_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = jbd2_seq_info_release,
+static const struct proc_ops jbd2_info_proc_ops = {
+	.proc_open	= jbd2_seq_info_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= jbd2_seq_info_release,
 };
 
 static struct proc_dir_entry *proc_jbd2_stats;
@@ -1089,7 +1088,7 @@ static void jbd2_stats_proc_init(journal_t *journal)
 	journal->j_proc_entry = proc_mkdir(journal->j_devname, proc_jbd2_stats);
 	if (journal->j_proc_entry) {
 		proc_create_data("info", S_IRUGO, journal->j_proc_entry,
-				 &jbd2_seq_info_fops, journal);
+				 &jbd2_info_proc_ops, journal);
 	}
 }
 
--- a/fs/jfs/jfs_debug.c
+++ b/fs/jfs/jfs_debug.c
@@ -43,12 +43,12 @@ static ssize_t jfs_loglevel_proc_write(struct file *file,
 	return count;
 }
 
-static const struct file_operations jfs_loglevel_proc_fops = {
-	.open		= jfs_loglevel_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= jfs_loglevel_proc_write,
+static const struct proc_ops jfs_loglevel_proc_ops = {
+	.proc_open	= jfs_loglevel_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= jfs_loglevel_proc_write,
 };
 #endif
 
@@ -68,7 +68,7 @@ void jfs_proc_init(void)
 #endif
 #ifdef CONFIG_JFS_DEBUG
 	proc_create_single("TxAnchor", 0, base, jfs_txanchor_proc_show);
-	proc_create("loglevel", 0, base, &jfs_loglevel_proc_fops);
+	proc_create("loglevel", 0, base, &jfs_loglevel_proc_ops);
 #endif
 }
 
--- a/fs/lockd/procfs.c
+++ b/fs/lockd/procfs.c
@@ -60,11 +60,11 @@ nlm_end_grace_read(struct file *file, char __user *buf, size_t size,
 	return simple_read_from_buffer(buf, size, pos, resp, sizeof(resp));
 }
 
-static const struct file_operations lockd_end_grace_operations = {
-	.write		= nlm_end_grace_write,
-	.read		= nlm_end_grace_read,
-	.llseek		= default_llseek,
-	.release	= simple_transaction_release,
+static const struct proc_ops lockd_end_grace_proc_ops = {
+	.proc_write	= nlm_end_grace_write,
+	.proc_read	= nlm_end_grace_read,
+	.proc_lseek	= default_llseek,
+	.proc_release	= simple_transaction_release,
 };
 
 int __init
@@ -76,7 +76,7 @@ lockd_create_procfs(void)
 	if (!entry)
 		return -ENOMEM;
 	entry = proc_create("nlm_end_grace", S_IRUGO|S_IWUSR, entry,
-				 &lockd_end_grace_operations);
+			    &lockd_end_grace_proc_ops);
 	if (!entry) {
 		remove_proc_entry("fs/lockd", NULL);
 		return -ENOMEM;
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -157,11 +157,11 @@ static int exports_proc_open(struct inode *inode, struct file *file)
 	return exports_net_open(current->nsproxy->net_ns, file);
 }
 
-static const struct file_operations exports_proc_operations = {
-	.open		= exports_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
+static const struct proc_ops exports_proc_ops = {
+	.proc_open	= exports_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release,
 };
 
 static int exports_nfsd_open(struct inode *inode, struct file *file)
@@ -1431,8 +1431,7 @@ static int create_proc_exports_entry(void)
 	entry = proc_mkdir("fs/nfs", NULL);
 	if (!entry)
 		return -ENOMEM;
-	entry = proc_create("exports", 0, entry,
-				 &exports_proc_operations);
+	entry = proc_create("exports", 0, entry, &exports_proc_ops);
 	if (!entry) {
 		remove_proc_entry("fs/nfs", NULL);
 		return -ENOMEM;
--- a/fs/nfsd/stats.c
+++ b/fs/nfsd/stats.c
@@ -84,17 +84,17 @@ static int nfsd_proc_open(struct inode *inode, struct file *file)
 	return single_open(file, nfsd_proc_show, NULL);
 }
 
-static const struct file_operations nfsd_proc_fops = {
-	.open = nfsd_proc_open,
-	.read  = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
+static const struct proc_ops nfsd_proc_ops = {
+	.proc_open	= nfsd_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
 };
 
 void
 nfsd_stat_init(void)
 {
-	svc_proc_register(&init_net, &nfsd_svcstats, &nfsd_proc_fops);
+	svc_proc_register(&init_net, &nfsd_svcstats, &nfsd_proc_ops);
 }
 
 void
--- a/fs/proc/cpuinfo.c
+++ b/fs/proc/cpuinfo.c
@@ -16,16 +16,16 @@ static int cpuinfo_open(struct inode *inode, struct file *file)
 	return seq_open(file, &cpuinfo_op);
 }
 
-static const struct file_operations proc_cpuinfo_operations = {
-	.open		= cpuinfo_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
+static const struct proc_ops cpuinfo_proc_ops = {
+	.proc_open	= cpuinfo_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release,
 };
 
 static int __init proc_cpuinfo_init(void)
 {
-	proc_create("cpuinfo", 0, NULL, &proc_cpuinfo_operations);
+	proc_create("cpuinfo", 0, NULL, &cpuinfo_proc_ops);
 	return 0;
 }
 fs_initcall(proc_cpuinfo_init);
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -574,11 +574,11 @@ static int release_kcore(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static const struct file_operations proc_kcore_operations = {
-	.read		= read_kcore,
-	.open		= open_kcore,
-	.release	= release_kcore,
-	.llseek		= default_llseek,
+static const struct proc_ops kcore_proc_ops = {
+	.proc_read	= read_kcore,
+	.proc_open	= open_kcore,
+	.proc_release	= release_kcore,
+	.proc_lseek	= default_llseek,
 };
 
 /* just remember that we have to update kcore */
@@ -637,8 +637,7 @@ static void __init add_modules_range(void)
 
 static int __init proc_kcore_init(void)
 {
-	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL,
-				      &proc_kcore_operations);
+	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &kcore_proc_ops);
 	if (!proc_root_kcore) {
 		pr_err("couldn't create /proc/kcore\n");
 		return 0; /* Always returns 0. */
--- a/fs/proc/kmsg.c
+++ b/fs/proc/kmsg.c
@@ -49,17 +49,17 @@ static __poll_t kmsg_poll(struct file *file, poll_table *wait)
 }
 
 
-static const struct file_operations proc_kmsg_operations = {
-	.read		= kmsg_read,
-	.poll		= kmsg_poll,
-	.open		= kmsg_open,
-	.release	= kmsg_release,
-	.llseek		= generic_file_llseek,
+static const struct proc_ops kmsg_proc_ops = {
+	.proc_read	= kmsg_read,
+	.proc_poll	= kmsg_poll,
+	.proc_open	= kmsg_open,
+	.proc_release	= kmsg_release,
+	.proc_lseek	= generic_file_llseek,
 };
 
 static int __init proc_kmsg_init(void)
 {
-	proc_create("kmsg", S_IRUSR, NULL, &proc_kmsg_operations);
+	proc_create("kmsg", S_IRUSR, NULL, &kmsg_proc_ops);
 	return 0;
 }
 fs_initcall(proc_kmsg_init);
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -71,9 +71,9 @@ static ssize_t kpagecount_read(struct file *file, char __user *buf,
 	return ret;
 }
 
-static const struct file_operations proc_kpagecount_operations = {
-	.llseek = mem_lseek,
-	.read = kpagecount_read,
+static const struct proc_ops kpagecount_proc_ops = {
+	.proc_lseek	= mem_lseek,
+	.proc_read	= kpagecount_read,
 };
 
 /* /proc/kpageflags - an array exposing page flags
@@ -242,9 +242,9 @@ static ssize_t kpageflags_read(struct file *file, char __user *buf,
 	return ret;
 }
 
-static const struct file_operations proc_kpageflags_operations = {
-	.llseek = mem_lseek,
-	.read = kpageflags_read,
+static const struct proc_ops kpageflags_proc_ops = {
+	.proc_lseek	= mem_lseek,
+	.proc_read	= kpageflags_read,
 };
 
 #ifdef CONFIG_MEMCG
@@ -293,18 +293,18 @@ static ssize_t kpagecgroup_read(struct file *file, char __user *buf,
 	return ret;
 }
 
-static const struct file_operations proc_kpagecgroup_operations = {
-	.llseek = mem_lseek,
-	.read = kpagecgroup_read,
+static const struct proc_ops kpagecgroup_proc_ops = {
+	.proc_lseek	= mem_lseek,
+	.proc_read	= kpagecgroup_read,
 };
 #endif /* CONFIG_MEMCG */
 
 static int __init proc_page_init(void)
 {
-	proc_create("kpagecount", S_IRUSR, NULL, &proc_kpagecount_operations);
-	proc_create("kpageflags", S_IRUSR, NULL, &proc_kpageflags_operations);
+	proc_create("kpagecount", S_IRUSR, NULL, &kpagecount_proc_ops);
+	proc_create("kpageflags", S_IRUSR, NULL, &kpageflags_proc_ops);
 #ifdef CONFIG_MEMCG
-	proc_create("kpagecgroup", S_IRUSR, NULL, &proc_kpagecgroup_operations);
+	proc_create("kpagecgroup", S_IRUSR, NULL, &kpagecgroup_proc_ops);
 #endif
 	return 0;
 }
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -223,16 +223,16 @@ static int stat_open(struct inode *inode, struct file *file)
 	return single_open_size(file, show_stat, NULL, size);
 }
 
-static const struct file_operations proc_stat_operations = {
-	.open		= stat_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
+static const struct proc_ops stat_proc_ops = {
+	.proc_open	= stat_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
 };
 
 static int __init proc_stat_init(void)
 {
-	proc_create("stat", 0, NULL, &proc_stat_operations);
+	proc_create("stat", 0, NULL, &stat_proc_ops);
 	return 0;
 }
 fs_initcall(proc_stat_init);
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -667,10 +667,10 @@ static int mmap_vmcore(struct file *file, struct vm_area_struct *vma)
 }
 #endif
 
-static const struct file_operations proc_vmcore_operations = {
-	.read		= read_vmcore,
-	.llseek		= default_llseek,
-	.mmap		= mmap_vmcore,
+static const struct proc_ops vmcore_proc_ops = {
+	.proc_read	= read_vmcore,
+	.proc_lseek	= default_llseek,
+	.proc_mmap	= mmap_vmcore,
 };
 
 static struct vmcore* __init get_new_element(void)
@@ -1555,7 +1555,7 @@ static int __init vmcore_init(void)
 	elfcorehdr_free(elfcorehdr_addr);
 	elfcorehdr_addr = ELFCORE_ADDR_ERR;
 
-	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
+	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &vmcore_proc_ops);
 	if (proc_vmcore)
 		proc_vmcore->size = vmcore_size;
 	return 0;
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -160,6 +160,19 @@ static const struct file_operations __name ## _fops = {			\
 	.release	= single_release,				\
 }
 
+#define DEFINE_PROC_SHOW_ATTRIBUTE(__name)				\
+static int __name ## _open(struct inode *inode, struct file *file)	\
+{									\
+	return single_open(file, __name ## _show, inode->i_private);	\
+}									\
+									\
+static const struct proc_ops __name ## _proc_ops = {			\
+	.proc_open	= __name ## _open,				\
+	.proc_read	= seq_read,					\
+	.proc_lseek	= seq_lseek,					\
+	.proc_release	= single_release,				\
+}
+
 static inline struct user_namespace *seq_user_ns(struct seq_file *seq)
 {
 #ifdef CONFIG_USER_NS
--- a/include/linux/sunrpc/stats.h
+++ b/include/linux/sunrpc/stats.h
@@ -63,7 +63,7 @@ struct proc_dir_entry *	rpc_proc_register(struct net *,struct rpc_stat *);
 void			rpc_proc_unregister(struct net *,const char *);
 void			rpc_proc_zero(const struct rpc_program *);
 struct proc_dir_entry *	svc_proc_register(struct net *, struct svc_stat *,
-					  const struct file_operations *);
+					  const struct proc_ops *);
 void			svc_proc_unregister(struct net *, const char *);
 
 void			svc_seq_show(struct seq_file *,
@@ -75,7 +75,7 @@ static inline void rpc_proc_unregister(struct net *net, const char *p) {}
 static inline void rpc_proc_zero(const struct rpc_program *p) {}
 
 static inline struct proc_dir_entry *svc_proc_register(struct net *net, struct svc_stat *s,
-						       const struct file_operations *f) { return NULL; }
+						       const struct proc_ops *proc_ops) { return NULL; }
 static inline void svc_proc_unregister(struct net *net, const char *p) {}
 
 static inline void svc_seq_show(struct seq_file *seq,
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -126,7 +126,7 @@ void ipc_init_ids(struct ipc_ids *ids)
 }
 
 #ifdef CONFIG_PROC_FS
-static const struct file_operations sysvipc_proc_fops;
+static const struct proc_ops sysvipc_proc_ops;
 /**
  * ipc_init_proc_interface -  create a proc interface for sysipc types using a seq_file interface.
  * @path: Path in procfs
@@ -151,7 +151,7 @@ void __init ipc_init_proc_interface(const char *path, const char *header,
 	pde = proc_create_data(path,
 			       S_IRUGO,        /* world readable */
 			       NULL,           /* parent dir */
-			       &sysvipc_proc_fops,
+			       &sysvipc_proc_ops,
 			       iface);
 	if (!pde)
 		kfree(iface);
@@ -884,10 +884,10 @@ static int sysvipc_proc_release(struct inode *inode, struct file *file)
 	return seq_release_private(inode, file);
 }
 
-static const struct file_operations sysvipc_proc_fops = {
-	.open    = sysvipc_proc_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = sysvipc_proc_release,
+static const struct proc_ops sysvipc_proc_ops = {
+	.proc_open	= sysvipc_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= sysvipc_proc_release,
 };
 #endif /* CONFIG_PROC_FS */
--- a/kernel/configs.c
+++ b/kernel/configs.c
@@ -47,10 +47,9 @@ ikconfig_read_current(struct file *file, char __user *buf,
 				       &kernel_config_data);
 }
 
-static const struct file_operations ikconfig_file_ops = {
-	.owner = THIS_MODULE,
-	.read = ikconfig_read_current,
-	.llseek = default_llseek,
+static const struct proc_ops config_gz_proc_ops = {
+	.proc_read	= ikconfig_read_current,
+	.proc_lseek	= default_llseek,
 };
 
 static int __init ikconfig_init(void)
@@ -59,7 +58,7 @@ static int __init ikconfig_init(void)
 
 	/* create the current config file */
 	entry = proc_create("config.gz", S_IFREG | S_IRUGO, NULL,
-			    &ikconfig_file_ops);
+			    &config_gz_proc_ops);
 	if (!entry)
 		return -ENOMEM;
 
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -176,20 +176,20 @@ static int irq_affinity_list_proc_open(struct inode *inode, struct file *file)
 	return single_open(file, irq_affinity_list_proc_show, PDE_DATA(inode));
 }
 
-static const struct file_operations irq_affinity_proc_fops = {
-	.open		= irq_affinity_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= irq_affinity_proc_write,
+static const struct proc_ops irq_affinity_proc_ops = {
+	.proc_open	= irq_affinity_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= irq_affinity_proc_write,
 };
 
-static const struct file_operations irq_affinity_list_proc_fops = {
-	.open		= irq_affinity_list_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= irq_affinity_list_proc_write,
+static const struct proc_ops irq_affinity_list_proc_ops = {
+	.proc_open	= irq_affinity_list_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= irq_affinity_list_proc_write,
 };
 
 #ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
@@ -246,12 +246,12 @@ static int default_affinity_open(struct inode *inode, struct file *file)
 	return single_open(file, default_affinity_show, PDE_DATA(inode));
 }
 
-static const struct file_operations default_affinity_proc_fops = {
-	.open		= default_affinity_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= default_affinity_write,
+static const struct proc_ops default_affinity_proc_ops = {
+	.proc_open	= default_affinity_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= default_affinity_write,
 };
 
 static int irq_node_proc_show(struct seq_file *m, void *v)
@@ -342,7 +342,7 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 #ifdef CONFIG_SMP
 	/* create /proc/irq/<irq>/smp_affinity */
 	proc_create_data("smp_affinity", 0644, desc->dir,
-			 &irq_affinity_proc_fops, irqp);
+			 &irq_affinity_proc_ops, irqp);
 
 	/* create /proc/irq/<irq>/affinity_hint */
 	proc_create_single_data("affinity_hint", 0444, desc->dir,
@@ -350,7 +350,7 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 
 	/* create /proc/irq/<irq>/smp_affinity_list */
 	proc_create_data("smp_affinity_list", 0644, desc->dir,
-			 &irq_affinity_list_proc_fops, irqp);
+			 &irq_affinity_list_proc_ops, irqp);
 
 	proc_create_single_data("node", 0444, desc->dir, irq_node_proc_show,
 			irqp);
@@ -401,7 +401,7 @@ static void register_default_affinity_proc(void)
 {
 #ifdef CONFIG_SMP
 	proc_create("irq/default_smp_affinity", 0644, NULL,
-		    &default_affinity_proc_fops);
+		    &default_affinity_proc_ops);
 #endif
 }
 
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -698,16 +698,16 @@ const char *kdb_walk_kallsyms(loff_t *pos)
 }
 #endif	/* CONFIG_KGDB_KDB */
 
-static const struct file_operations kallsyms_operations = {
-	.open = kallsyms_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release_private,
+static const struct proc_ops kallsyms_proc_ops = {
+	.proc_open	= kallsyms_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release_private,
 };
 
 static int __init kallsyms_init(void)
 {
-	proc_create("kallsyms", 0444, NULL, &kallsyms_operations);
+	proc_create("kallsyms", 0444, NULL, &kallsyms_proc_ops);
 	return 0;
 }
 device_initcall(kallsyms_init);
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -255,17 +255,17 @@ static int lstats_open(struct inode *inode, struct file *filp)
 	return single_open(filp, lstats_show, NULL);
 }
 
-static const struct file_operations lstats_fops = {
-	.open		= lstats_open,
-	.read		= seq_read,
-	.write		= lstats_write,
-	.llseek		= seq_lseek,
-	.release	= single_release,
+static const struct proc_ops lstats_proc_ops = {
+	.proc_open	= lstats_open,
+	.proc_read	= seq_read,
+	.proc_write	= lstats_write,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
 };
 
 static int __init init_lstats_procfs(void)
 {
-	proc_create("latency_stats", 0644, NULL, &lstats_fops);
+	proc_create("latency_stats", 0644, NULL, &lstats_proc_ops);
 	return 0;
 }
 
--- a/kernel/locking/lockdep_proc.c
+++ b/kernel/locking/lockdep_proc.c
@@ -643,12 +643,12 @@ static int lock_stat_release(struct inode *inode, struct file *file)
 	return seq_release(inode, file);
 }
 
-static const struct file_operations proc_lock_stat_operations = {
-	.open		= lock_stat_open,
-	.write		= lock_stat_write,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= lock_stat_release,
+static const struct proc_ops lock_stat_proc_ops = {
+	.proc_open	= lock_stat_open,
+	.proc_write	= lock_stat_write,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= lock_stat_release,
 };
 #endif /* CONFIG_LOCK_STAT */
 
@@ -660,8 +660,7 @@ static int __init lockdep_proc_init(void)
 #endif
 	proc_create_single("lockdep_stats", S_IRUSR, NULL, lockdep_stats_show);
 #ifdef CONFIG_LOCK_STAT
-	proc_create("lock_stat", S_IRUSR | S_IWUSR, NULL,
-		    &proc_lock_stat_operations);
+	proc_create("lock_stat", S_IRUSR | S_IWUSR, NULL, &lock_stat_proc_ops);
 #endif
 
 	return 0;
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4393,16 +4393,16 @@ static int modules_open(struct inode *inode, struct file *file)
 	return err;
 }
 
-static const struct file_operations proc_modules_operations = {
-	.open		= modules_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
+static const struct proc_ops modules_proc_ops = {
+	.proc_open	= modules_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release,
 };
 
 static int __init proc_modules_init(void)
 {
-	proc_create("modules", 0, NULL, &proc_modules_operations);
+	proc_create("modules", 0, NULL, &modules_proc_ops);
 	return 0;
 }
 module_init(proc_modules_init);
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -442,18 +442,18 @@ static ssize_t prof_cpu_mask_proc_write(struct file *file,
 	return err;
 }
 
-static const struct file_operations prof_cpu_mask_proc_fops = {
-	.open		= prof_cpu_mask_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= prof_cpu_mask_proc_write,
+static const struct proc_ops prof_cpu_mask_proc_ops = {
+	.proc_open	= prof_cpu_mask_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
+	.proc_write	= prof_cpu_mask_proc_write,
 };
 
 void create_prof_cpu_mask(void)
 {
 	/* create /proc/irq/prof_cpu_mask */
-	proc_create("irq/prof_cpu_mask", 0600, NULL, &prof_cpu_mask_proc_fops);
+	proc_create("irq/prof_cpu_mask", 0600, NULL, &prof_cpu_mask_proc_ops);
 }
 
 /*
@@ -517,10 +517,10 @@ static ssize_t write_profile(struct file *file, const char __user *buf,
 	return count;
 }
 
-static const struct file_operations proc_profile_operations = {
-	.read		= read_profile,
-	.write		= write_profile,
-	.llseek		= default_llseek,
+static const struct proc_ops profile_proc_ops = {
+	.proc_read	= read_profile,
+	.proc_write	= write_profile,
+	.proc_lseek	= default_llseek,
 };
 
 int __ref create_proc_profile(void)
@@ -548,7 +548,7 @@ int __ref create_proc_profile(void)
 	err = 0;
 #endif
 	entry = proc_create("profile", S_IWUSR | S_IRUGO,
-			    NULL, &proc_profile_operations);
+			    NULL, &profile_proc_ops);
 	if (!entry)
 		goto err_state_onl;
 	proc_set_size(entry, (1 + prof_len) * sizeof(atomic_t));
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1251,39 +1251,39 @@ static int psi_fop_release(struct inode *inode, struct file *file)
 	return single_release(inode, file);
 }
 
-static const struct file_operations psi_io_fops = {
-	.open           = psi_io_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.write          = psi_io_write,
-	.poll           = psi_fop_poll,
-	.release        = psi_fop_release,
+static const struct proc_ops psi_io_proc_ops = {
+	.proc_open	= psi_io_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= psi_io_write,
+	.proc_poll	= psi_fop_poll,
+	.proc_release	= psi_fop_release,
 };
 
-static const struct file_operations psi_memory_fops = {
-	.open           = psi_memory_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.write          = psi_memory_write,
-	.poll           = psi_fop_poll,
-	.release        = psi_fop_release,
+static const struct proc_ops psi_memory_proc_ops = {
+	.proc_open	= psi_memory_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= psi_memory_write,
+	.proc_poll	= psi_fop_poll,
+	.proc_release	= psi_fop_release,
 };
 
-static const struct file_operations psi_cpu_fops = {
-	.open           = psi_cpu_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.write          = psi_cpu_write,
-	.poll           = psi_fop_poll,
-	.release        = psi_fop_release,
+static const struct proc_ops psi_cpu_proc_ops = {
+	.proc_open	= psi_cpu_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= psi_cpu_write,
+	.proc_poll	= psi_fop_poll,
+	.proc_release	= psi_fop_release,
 };
 
 static int __init psi_proc_init(void)
 {
 	proc_mkdir("pressure", NULL);
-	proc_create("pressure/io", 0, NULL, &psi_io_fops);
-	proc_create("pressure/memory", 0, NULL, &psi_memory_fops);
-	proc_create("pressure/cpu", 0, NULL, &psi_cpu_fops);
+	proc_create("pressure/io", 0, NULL, &psi_io_proc_ops);
+	proc_create("pressure/memory", 0, NULL, &psi_memory_proc_ops);
+	proc_create("pressure/cpu", 0, NULL, &psi_cpu_proc_ops);
 	return 0;
 }
 module_init(psi_proc_init);
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1579,18 +1579,17 @@ static int slabinfo_open(struct inode *inode, struct file *file)
 	return seq_open(file, &slabinfo_op);
 }
 
-static const struct file_operations proc_slabinfo_operations = {
-	.open		= slabinfo_open,
-	.read		= seq_read,
-	.write          = slabinfo_write,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
+static const struct proc_ops slabinfo_proc_ops = {
+	.proc_open	= slabinfo_open,
+	.proc_read	= seq_read,
+	.proc_write	= slabinfo_write,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release,
 };
 
 static int __init slab_proc_init(void)
 {
-	proc_create("slabinfo", SLABINFO_RIGHTS, NULL,
-						&proc_slabinfo_operations);
+	proc_create("slabinfo", SLABINFO_RIGHTS, NULL, &slabinfo_proc_ops);
 	return 0;
 }
 module_init(slab_proc_init);
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2796,17 +2796,17 @@ static int swaps_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static const struct file_operations proc_swaps_operations = {
-	.open		= swaps_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-	.poll		= swaps_poll,
+static const struct proc_ops swaps_proc_ops = {
+	.proc_open	= swaps_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release,
+	.proc_poll	= swaps_poll,
 };
 
 static int __init procswaps_init(void)
 {
-	proc_create("swaps", 0, NULL, &proc_swaps_operations);
+	proc_create("swaps", 0, NULL, &swaps_proc_ops);
 	return 0;
 }
 __initcall(procswaps_init);
--- a/net/atm/mpoa_proc.c
+++ b/net/atm/mpoa_proc.c
@@ -53,15 +53,12 @@ static ssize_t proc_mpc_write(struct file *file, const char __user *buff,
 
 static int parse_qos(const char *buff);
 
-/*
- *   Define allowed FILE OPERATIONS
- */
-static const struct file_operations mpc_file_operations = {
-	.open =		proc_mpc_open,
-	.read =		seq_read,
-	.llseek =	seq_lseek,
-	.write =	proc_mpc_write,
-	.release =	seq_release,
+static const struct proc_ops mpc_proc_ops = {
+	.proc_open	= proc_mpc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= proc_mpc_write,
+	.proc_release	= seq_release,
 };
 
 /*
@@ -290,7 +287,7 @@ int mpc_proc_init(void)
 {
 	struct proc_dir_entry *p;
 
-	p = proc_create(STAT_FILE_NAME, 0, atm_proc_root, &mpc_file_operations);
+	p = proc_create(STAT_FILE_NAME, 0, atm_proc_root, &mpc_proc_ops);
 	if (!p) {
 		pr_err("Unable to initialize /proc/atm/%s\n", STAT_FILE_NAME);
 		return -ENOMEM;
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -36,9 +36,9 @@
 static ssize_t proc_dev_atm_read(struct file *file, char __user *buf,
 				 size_t count, loff_t *pos);
 
-static const struct file_operations proc_atm_dev_ops = {
-	.read =		proc_dev_atm_read,
-	.llseek =	noop_llseek,
+static const struct proc_ops atm_dev_proc_ops = {
+	.proc_read	= proc_dev_atm_read,
+	.proc_lseek	= noop_llseek,
 };
 
 static void add_stats(struct seq_file *seq, const char *aal,
@@ -360,7 +360,7 @@ int atm_proc_dev_register(struct atm_dev *dev)
 		goto err_out;
 
 	dev->proc_entry = proc_create_data(dev->proc_name, 0, atm_proc_root,
-					   &proc_atm_dev_ops, dev);
+					   &atm_dev_proc_ops, dev);
 	if (!dev->proc_entry)
 		goto err_free_name;
 	return 0;
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -535,12 +535,12 @@ static int pgctrl_open(struct inode *inode, struct file *file)
 	return single_open(file, pgctrl_show, PDE_DATA(inode));
 }
 
-static const struct file_operations pktgen_fops = {
-	.open    = pgctrl_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.write   = pgctrl_write,
-	.release = single_release,
+static const struct proc_ops pktgen_proc_ops = {
+	.proc_open	= pgctrl_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= pgctrl_write,
+	.proc_release	= single_release,
 };
 
 static int pktgen_if_show(struct seq_file *seq, void *v)
@@ -1707,12 +1707,12 @@ static int pktgen_if_open(struct inode *inode, struct file *file)
 	return single_open(file, pktgen_if_show, PDE_DATA(inode));
 }
 
-static const struct file_operations pktgen_if_fops = {
-	.open    = pktgen_if_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.write   = pktgen_if_write,
-	.release = single_release,
+static const struct proc_ops pktgen_if_proc_ops = {
+	.proc_open	= pktgen_if_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= pktgen_if_write,
+	.proc_release	= single_release,
 };
 
 static int pktgen_thread_show(struct seq_file *seq, void *v)
@@ -1844,12 +1844,12 @@ static int pktgen_thread_open(struct inode *inode, struct file *file)
 	return single_open(file, pktgen_thread_show, PDE_DATA(inode));
 }
 
-static const struct file_operations pktgen_thread_fops = {
-	.open    = pktgen_thread_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.write   = pktgen_thread_write,
-	.release = single_release,
+static const struct proc_ops pktgen_thread_proc_ops = {
+	.proc_open	= pktgen_thread_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_write	= pktgen_thread_write,
+	.proc_release	= single_release,
 };
 
 /* Think find or remove for NN */
@@ -1926,7 +1926,7 @@ static void pktgen_change_name(const struct pktgen_net *pn, struct net_device *d
 
 			pkt_dev->entry = proc_create_data(dev->name, 0600,
 							  pn->proc_dir,
-							  &pktgen_if_fops,
+							  &pktgen_if_proc_ops,
 							  pkt_dev);
 			if (!pkt_dev->entry)
 				pr_err("can't move proc entry for '%s'\n",
@@ -3638,7 +3638,7 @@ static int pktgen_add_device(struct pktgen_thread *t, const char *ifname)
 		pkt_dev->clone_skb = pg_clone_skb_d;
 
 	pkt_dev->entry = proc_create_data(ifname, 0600, t->net->proc_dir,
-					  &pktgen_if_fops, pkt_dev);
+					  &pktgen_if_proc_ops, pkt_dev);
 	if (!pkt_dev->entry) {
 		pr_err("cannot create %s/%s procfs entry\n",
 		       PG_PROC_DIR, ifname);
@@ -3708,7 +3708,7 @@ static int __net_init pktgen_create_thread(int cpu, struct pktgen_net *pn)
 	t->tsk = p;
 
 	pe = proc_create_data(t->tsk->comm, 0600, pn->proc_dir,
-			      &pktgen_thread_fops, t);
+			      &pktgen_thread_proc_ops, t);
 	if (!pe) {
 		pr_err("cannot create %s/%s procfs entry\n",
 		       PG_PROC_DIR, t->tsk->comm);
@@ -3793,7 +3793,7 @@ static int __net_init pg_net_init(struct net *net)
 		pr_warn("cannot create /proc/net/%s\n", PG_PROC_DIR);
 		return -ENODEV;
 	}
-	pe = proc_create(PGCTRL, 0600, pn->proc_dir, &pktgen_fops);
+	pe = proc_create(PGCTRL, 0600, pn->proc_dir, &pktgen_proc_ops);
 	if (pe == NULL) {
 		pr_err("cannot create %s procfs entry\n", PGCTRL);
 		ret = -EINVAL;
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1334,7 +1334,7 @@ static int __init ipconfig_proc_net_init(void)
 
 /* Create a new file under /proc/net/ipconfig */
 static int ipconfig_proc_net_create(const char *name,
-				    const struct file_operations *fops)
+				    const struct proc_ops *proc_ops)
 {
 	char *pname;
 	struct proc_dir_entry *p;
@@ -1346,7 +1346,7 @@ static int ipconfig_proc_net_create(const char *name,
 	if (!pname)
 		return -ENOMEM;
 
-	p = proc_create(pname, 0444, init_net.proc_net, fops);
+	p = proc_create(pname, 0444, init_net.proc_net, proc_ops);
 	kfree(pname);
 	if (!p)
 		return -ENOMEM;
@@ -1355,7 +1355,7 @@ static int ipconfig_proc_net_create(const char *name,
 }
 
 /* Write NTP server IP addresses to /proc/net/ipconfig/ntp_servers */
-static int ntp_servers_seq_show(struct seq_file *seq, void *v)
+static int ntp_servers_show(struct seq_file *seq, void *v)
 {
 	int i;
 
@@ -1365,7 +1365,7 @@ static int ntp_servers_seq_show(struct seq_file *seq, void *v)
 	}
 	return 0;
 }
-DEFINE_SHOW_ATTRIBUTE(ntp_servers_seq);
+DEFINE_PROC_SHOW_ATTRIBUTE(ntp_servers);
 #endif /* CONFIG_PROC_FS */
 
 /*
@@ -1456,7 +1456,7 @@ static int __init ip_auto_config(void)
 	proc_create_single("pnp", 0444, init_net.proc_net, pnp_seq_show);
 
 	if (ipconfig_proc_net_init() == 0)
-		ipconfig_proc_net_create("ntp_servers", &ntp_servers_seq_fops);
+		ipconfig_proc_net_create("ntp_servers", &ntp_servers_proc_ops);
 #endif /* CONFIG_PROC_FS */
 
 	if (!ic_enable)
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -58,7 +58,7 @@ struct clusterip_config {
 };
 
 #ifdef CONFIG_PROC_FS
-static const struct file_operations clusterip_proc_fops;
+static const struct proc_ops clusterip_proc_ops;
 #endif
 
 struct clusterip_net {
@@ -280,7 +280,7 @@ clusterip_config_init(struct net *net, const struct ipt_clusterip_tgt_info *i,
 		mutex_lock(&cn->mutex);
 		c->pde = proc_create_data(buffer, 0600,
 					  cn->procdir,
-					  &clusterip_proc_fops, c);
+					  &clusterip_proc_ops, c);
 		mutex_unlock(&cn->mutex);
 		if (!c->pde) {
 			err = -ENOMEM;
@@ -804,12 +804,12 @@ static ssize_t clusterip_proc_write(struct file *file, const char __user *input,
 	return size;
 }
 
-static const struct file_operations clusterip_proc_fops = {
-	.open	 = clusterip_proc_open,
-	.read	 = seq_read,
-	.write	 = clusterip_proc_write,
-	.llseek	 = seq_lseek,
-	.release = clusterip_proc_release,
+static const struct proc_ops clusterip_proc_ops = {
+	.proc_open	= clusterip_proc_open,
+	.proc_read	= seq_read,
+	.proc_write	= clusterip_proc_write,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= clusterip_proc_release,
 };
 
 #endif /* CONFIG_PROC_FS */
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -236,11 +236,11 @@ static int rt_cache_seq_open(struct inode *inode, struct file *file)
 	return seq_open(file, &rt_cache_seq_ops);
 }
 
-static const struct file_operations rt_cache_seq_fops = {
-	.open	 = rt_cache_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release,
+static const struct proc_ops rt_cache_proc_ops = {
+	.proc_open	= rt_cache_seq_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release,
 };
 
 
@@ -326,11 +326,11 @@ static int rt_cpu_seq_open(struct inode *inode, struct file *file)
 	return seq_open(file, &rt_cpu_seq_ops);
 }
 
-static const struct file_operations rt_cpu_seq_fops = {
-	.open	 = rt_cpu_seq_open,
-	.read	 = seq_read,
-	.llseek	 = seq_lseek,
-	.release = seq_release,
+static const struct proc_ops rt_cpu_proc_ops = {
+	.proc_open	= rt_cpu_seq_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release,
 };
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
@@ -364,12 +364,12 @@ static int __net_init ip_rt_do_proc_init(struct net *net)
 	struct proc_dir_entry *pde;
 
 	pde = proc_create("rt_cache", 0444, net->proc_net,
-			  &rt_cache_seq_fops);
+			  &rt_cache_proc_ops);
 	if (!pde)
 		goto err1;
 
 	pde = proc_create("rt_cache", 0444,
-			  net->proc_net_stat, &rt_cpu_seq_fops);
+			  net->proc_net_stat, &rt_cpu_proc_ops);
 	if (!pde)
 		goto err2;
 
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -103,7 +103,7 @@ static DEFINE_SPINLOCK(recent_lock);
 static DEFINE_MUTEX(recent_mutex);
 
 #ifdef CONFIG_PROC_FS
-static const struct file_operations recent_mt_fops;
+static const struct proc_ops recent_mt_proc_ops;
 #endif
 
 static u_int32_t hash_rnd __read_mostly;
@@ -405,7 +405,7 @@ static int recent_mt_check(const struct xt_mtchk_param *par,
 		goto out;
 	}
 	pde = proc_create_data(t->name, ip_list_perms, recent_net->xt_recent,
-		  &recent_mt_fops, t);
+			       &recent_mt_proc_ops, t);
 	if (pde == NULL) {
 		recent_table_free(t);
 		ret = -ENOMEM;
@@ -616,13 +616,12 @@ recent_mt_proc_write(struct file *file, const char __user *input,
 	return size + 1;
 }
 
-static const struct file_operations recent_mt_fops = {
-	.open    = recent_seq_open,
-	.read    = seq_read,
-	.write   = recent_mt_proc_write,
-	.release = seq_release_private,
-	.owner   = THIS_MODULE,
-	.llseek = seq_lseek,
+static const struct proc_ops recent_mt_proc_ops = {
+	.proc_open	= recent_seq_open,
+	.proc_read	= seq_read,
+	.proc_write	= recent_mt_proc_write,
+	.proc_release	= seq_release_private,
+	.proc_lseek	= seq_lseek,
 };
 
 static int __net_init recent_proc_net_init(struct net *net)
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1428,10 +1428,10 @@ static ssize_t read_gssp(struct file *file, char __user *buf,
 	return len;
 }
 
-static const struct file_operations use_gss_proxy_ops = {
-	.open = nonseekable_open,
-	.write = write_gssp,
-	.read = read_gssp,
+static const struct proc_ops use_gss_proxy_proc_ops = {
+	.proc_open	= nonseekable_open,
+	.proc_write	= write_gssp,
+	.proc_read	= read_gssp,
 };
 
 static int create_use_gss_proxy_proc_entry(struct net *net)
@@ -1442,7 +1442,7 @@ static int create_use_gss_proxy_proc_entry(struct net *net)
 	sn->use_gss_proxy = -1;
 	*p = proc_create_data("use-gss-proxy", S_IFREG | 0600,
 			      sn->proc_net_rpc,
-			      &use_gss_proxy_ops, net);
+			      &use_gss_proxy_proc_ops, net);
 	if (!*p)
 		return -ENOMEM;
 	init_gssp_clnt(sn);
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1571,15 +1571,14 @@ static int cache_release_procfs(struct inode *inode, struct file *filp)
 	return cache_release(inode, filp, cd);
 }
 
-static const struct file_operations cache_file_operations_procfs = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.read		= cache_read_procfs,
-	.write		= cache_write_procfs,
-	.poll		= cache_poll_procfs,
-	.unlocked_ioctl	= cache_ioctl_procfs, /* for FIONREAD */
-	.open		= cache_open_procfs,
-	.release	= cache_release_procfs,
+static const struct proc_ops cache_channel_proc_ops = {
+	.proc_lseek	= no_llseek,
+	.proc_read	= cache_read_procfs,
+	.proc_write	= cache_write_procfs,
+	.proc_poll	= cache_poll_procfs,
+	.proc_ioctl	= cache_ioctl_procfs, /* for FIONREAD */
+	.proc_open	= cache_open_procfs,
+	.proc_release	= cache_release_procfs,
 };
 
 static int content_open_procfs(struct inode *inode, struct file *filp)
@@ -1596,11 +1595,11 @@ static int content_release_procfs(struct inode *inode, struct file *filp)
 	return content_release(inode, filp, cd);
 }
 
-static const struct file_operations content_file_operations_procfs = {
-	.open		= content_open_procfs,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= content_release_procfs,
+static const struct proc_ops content_proc_ops = {
+	.proc_open	= content_open_procfs,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= content_release_procfs,
 };
 
 static int open_flush_procfs(struct inode *inode, struct file *filp)
@@ -1634,12 +1633,12 @@ static ssize_t write_flush_procfs(struct file *filp,
 	return write_flush(filp, buf, count, ppos, cd);
 }
 
-static const struct file_operations cache_flush_operations_procfs = {
-	.open		= open_flush_procfs,
-	.read		= read_flush_procfs,
-	.write		= write_flush_procfs,
-	.release	= release_flush_procfs,
-	.llseek		= no_llseek,
+static const struct proc_ops cache_flush_proc_ops = {
+	.proc_open	= open_flush_procfs,
+	.proc_read	= read_flush_procfs,
+	.proc_write	= write_flush_procfs,
+	.proc_release	= release_flush_procfs,
+	.proc_lseek	= no_llseek,
 };
 
 static void remove_cache_proc_entries(struct cache_detail *cd)
@@ -1662,19 +1661,19 @@ static int create_cache_proc_entries(struct cache_detail *cd, struct net *net)
 		goto out_nomem;
 
 	p = proc_create_data("flush", S_IFREG | 0600,
-			     cd->procfs, &cache_flush_operations_procfs, cd);
+			     cd->procfs, &cache_flush_proc_ops, cd);
 	if (p == NULL)
 		goto out_nomem;
 
 	if (cd->cache_request || cd->cache_parse) {
 		p = proc_create_data("channel", S_IFREG | 0600, cd->procfs,
-				     &cache_file_operations_procfs, cd);
+				     &cache_channel_proc_ops, cd);
 		if (p == NULL)
 			goto out_nomem;
 	}
 	if (cd->cache_show) {
 		p = proc_create_data("content", S_IFREG | 0400, cd->procfs,
-				     &content_file_operations_procfs, cd);
+				     &content_proc_ops, cd);
 		if (p == NULL)
 			goto out_nomem;
 	}
--- a/net/sunrpc/stats.c
+++ b/net/sunrpc/stats.c
@@ -69,12 +69,11 @@ static int rpc_proc_open(struct inode *inode, struct file *file)
 	return single_open(file, rpc_proc_show, PDE_DATA(inode));
 }
 
-static const struct file_operations rpc_proc_fops = {
-	.owner = THIS_MODULE,
-	.open = rpc_proc_open,
-	.read  = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
+static const struct proc_ops rpc_proc_ops = {
+	.proc_open	= rpc_proc_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= single_release,
 };
 
 /*
@@ -281,19 +280,19 @@ EXPORT_SYMBOL_GPL(rpc_clnt_show_stats);
  */
 static inline struct proc_dir_entry *
 do_register(struct net *net, const char *name, void *data,
-	    const struct file_operations *fops)
+	    const struct proc_ops *proc_ops)
 {
 	struct sunrpc_net *sn;
 
 	dprintk("RPC:       registering /proc/net/rpc/%s\n", name);
 	sn = net_generic(net, sunrpc_net_id);
-	return proc_create_data(name, 0, sn->proc_net_rpc, fops, data);
+	return proc_create_data(name, 0, sn->proc_net_rpc, proc_ops, data);
 }
 
 struct proc_dir_entry *
 rpc_proc_register(struct net *net, struct rpc_stat *statp)
 {
-	return do_register(net, statp->program->name, statp, &rpc_proc_fops);
+	return do_register(net, statp->program->name, statp, &rpc_proc_ops);
 }
 EXPORT_SYMBOL_GPL(rpc_proc_register);
 
@@ -308,9 +307,9 @@ rpc_proc_unregister(struct net *net, const char *name)
 EXPORT_SYMBOL_GPL(rpc_proc_unregister);
 
 struct proc_dir_entry *
-svc_proc_register(struct net *net, struct svc_stat *statp, const struct file_operations *fops)
+svc_proc_register(struct net *net, struct svc_stat *statp, const struct proc_ops *proc_ops)
 {
-	return do_register(net, statp->program->pg_name, statp, fops);
+	return do_register(net, statp->program->pg_name, statp, proc_ops);
 }
 EXPORT_SYMBOL_GPL(svc_proc_register);
 
--- a/samples/kfifo/bytestream-example.c
+++ b/samples/kfifo/bytestream-example.c
@@ -142,11 +142,10 @@ static ssize_t fifo_read(struct file *file, char __user *buf,
 	return ret ? ret : copied;
 }
 
-static const struct file_operations fifo_fops = {
-	.owner		= THIS_MODULE,
-	.read		= fifo_read,
-	.write		= fifo_write,
-	.llseek		= noop_llseek,
+static const struct proc_ops fifo_proc_ops = {
+	.proc_read	= fifo_read,
+	.proc_write	= fifo_write,
+	.proc_lseek	= noop_llseek,
 };
 
 static int __init example_init(void)
@@ -169,7 +168,7 @@ static int __init example_init(void)
 		return -EIO;
 	}
 
-	if (proc_create(PROC_FIFO, 0, NULL, &fifo_fops) == NULL) {
+	if (proc_create(PROC_FIFO, 0, NULL, &fifo_proc_ops) == NULL) {
 #ifdef DYNAMIC
 		kfifo_free(&test);
 #endif
--- a/samples/kfifo/inttype-example.c
+++ b/samples/kfifo/inttype-example.c
@@ -135,11 +135,10 @@ static ssize_t fifo_read(struct file *file, char __user *buf,
 	return ret ? ret : copied;
 }
 
-static const struct file_operations fifo_fops = {
-	.owner		= THIS_MODULE,
-	.read		= fifo_read,
-	.write		= fifo_write,
-	.llseek		= noop_llseek,
+static const struct proc_ops fifo_proc_ops = {
+	.proc_read	= fifo_read,
+	.proc_write	= fifo_write,
+	.proc_lseek	= noop_llseek,
 };
 
 static int __init example_init(void)
@@ -160,7 +159,7 @@ static int __init example_init(void)
 		return -EIO;
 	}
 
-	if (proc_create(PROC_FIFO, 0, NULL, &fifo_fops) == NULL) {
+	if (proc_create(PROC_FIFO, 0, NULL, &fifo_proc_ops) == NULL) {
 #ifdef DYNAMIC
 		kfifo_free(&test);
 #endif
--- a/samples/kfifo/record-example.c
+++ b/samples/kfifo/record-example.c
@@ -149,11 +149,10 @@ static ssize_t fifo_read(struct file *file, char __user *buf,
 	return ret ? ret : copied;
 }
 
-static const struct file_operations fifo_fops = {
-	.owner		= THIS_MODULE,
-	.read		= fifo_read,
-	.write		= fifo_write,
-	.llseek		= noop_llseek,
+static const struct proc_ops fifo_proc_ops = {
+	.proc_read	= fifo_read,
+	.proc_write	= fifo_write,
+	.proc_lseek	= noop_llseek,
 };
 
 static int __init example_init(void)
@@ -176,7 +175,7 @@ static int __init example_init(void)
 		return -EIO;
 	}
 
-	if (proc_create(PROC_FIFO, 0, NULL, &fifo_fops) == NULL) {
+	if (proc_create(PROC_FIFO, 0, NULL, &fifo_proc_ops) == NULL) {
 #ifdef DYNAMIC
 		kfifo_free(&test);
 #endif
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -282,17 +282,16 @@ static int snd_info_entry_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static const struct file_operations snd_info_entry_operations =
-{
-	.owner =		THIS_MODULE,
-	.llseek =		snd_info_entry_llseek,
-	.read =			snd_info_entry_read,
-	.write =		snd_info_entry_write,
-	.poll =			snd_info_entry_poll,
-	.unlocked_ioctl =	snd_info_entry_ioctl,
-	.mmap =			snd_info_entry_mmap,
-	.open =			snd_info_entry_open,
-	.release =		snd_info_entry_release,
+static const struct proc_ops snd_info_entry_operations =
+{
+	.proc_lseek	= snd_info_entry_llseek,
+	.proc_read	= snd_info_entry_read,
+	.proc_write	= snd_info_entry_write,
+	.proc_poll	= snd_info_entry_poll,
+	.proc_ioctl	= snd_info_entry_ioctl,
+	.proc_mmap	= snd_info_entry_mmap,
+	.proc_open	= snd_info_entry_open,
+	.proc_release	= snd_info_entry_release,
 };
 
 /*
@@ -421,14 +420,13 @@ static int snd_info_text_entry_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static const struct file_operations snd_info_text_entry_ops =
+static const struct proc_ops snd_info_text_entry_ops =
 {
-	.owner =		THIS_MODULE,
-	.open =			snd_info_text_entry_open,
-	.release =		snd_info_text_entry_release,
-	.write =		snd_info_text_entry_write,
-	.llseek =		seq_lseek,
-	.read =			seq_read,
+	.proc_open	= snd_info_text_entry_open,
+	.proc_release	= snd_info_text_entry_release,
+	.proc_write	= snd_info_text_entry_write,
+	.proc_lseek	= seq_lseek,
+	.proc_read	= seq_read,
 };
 
 static struct snd_info_entry *create_subdir(struct module *mod,
@@ -810,7 +808,7 @@ static int __snd_info_register(struct snd_info_entry *entry)
 			return -ENOMEM;
 		}
 	} else {
-		const struct file_operations *ops;
+		const struct proc_ops *ops;
 		if (entry->content == SNDRV_INFO_CONTENT_DATA)
 			ops = &snd_info_entry_operations;
 		else
