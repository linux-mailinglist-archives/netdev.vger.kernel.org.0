Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF571B4FBA
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 00:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgDVWBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 18:01:54 -0400
Received: from mail.hallyn.com ([178.63.66.53]:47630 "EHLO mail.hallyn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgDVWBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 18:01:54 -0400
Received: by mail.hallyn.com (Postfix, from userid 1001)
        id 280BD7DD; Wed, 22 Apr 2020 17:01:49 -0500 (CDT)
Date:   Wed, 22 Apr 2020 17:01:49 -0500
From:   "Serge E. Hallyn" <serge@hallyn.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        Steve Barber <smbarber@google.com>,
        Dylan Reid <dgreid@google.com>,
        Filipe Brandenburger <filbranden@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Benjamin Elder <bentheelder@google.com>,
        Akihiro Suda <suda.kyoto@gmail.com>
Subject: Re: [PATCH v2 4/7] kernfs: handle multiple namespace tags
Message-ID: <20200422220149.GA892@mail.hallyn.com>
References: <20200422145437.176057-1-christian.brauner@ubuntu.com>
 <20200422145437.176057-5-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422145437.176057-5-christian.brauner@ubuntu.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 04:54:34PM +0200, Christian Brauner wrote:
> Since [1] kernfs supports namespace tags. This feature is essential to
> enable sysfs to present different views of on various parts depending on
> the namespace tag. For example, the /sys/class/net/ directory will only
> show network devices that belong to the network namespace that sysfs was
> mounted in. This is achieved by stashing a reference to the network
> namespace of the task mounting sysfs in the super block. And when a
> lookup operation is performed on e.g. /sys/class/net/ kernfs will
> compare the network namespace tag of the kernfs_node associated with the
> device and kobject of the network device to the network namespace of the
> network device. This ensures that only network devices owned by the
> network namespace sysfs was mounted in are shown, a feature which is
> essential to containers.
> For loopfs to show correct permissions in sysfs just as with network
> devices we need to be able to tag kernfs_super_info with additional
> namespaces. This extension was even already mentioned in a comment to
> struct kernfs_super_info:
>   /*
>    * Each sb is associated with one namespace tag, currently the
>    * network namespace of the task which mounted this kernfs
>    * instance.  If multiple tags become necessary, make the following
>    * an array and compare kernfs_node tag against every entry.
>    */
> This patch extends the kernfs_super_info and kernfs_fs_context ns
> pointers to fixed-size arrays of namespace tags. The size is taken from
> the namespaces currently supported by kobjects, i.e. we don't extend it
> to cover all namespace but only the ones kernfs needs to support.
> In addition, the kernfs_node struct gains an additional member that
> indicates the type of namespace this kernfs_node was tagged with. This
> allows us to simply retrieve the correct namespace tag from the
> kernfs_fs_context and kernfs_super_info ns array with a simple indexing
> operation. This has the advantage that we can just keep passing down the
> correct namespace instead of passing down the array.
> 
> [1]: 608b4b9548de ("netns: Teach network device kobjects which namespace they are in.")
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Serge Hallyn <serge@hallyn.com>

> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
> /* v2 */
> unchanged
> ---
>  fs/kernfs/dir.c             |  6 +++---
>  fs/kernfs/kernfs-internal.h |  9 ++++-----
>  fs/kernfs/mount.c           | 11 +++++++----
>  fs/sysfs/mount.c            | 10 +++++-----
>  include/linux/kernfs.h      | 22 ++++++++++++++--------
>  include/linux/sysfs.h       |  8 +++++---
>  lib/kobject.c               |  2 +-
>  7 files changed, 39 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
> index 9aec80b9d7c6..1f2d894ae454 100644
> --- a/fs/kernfs/dir.c
> +++ b/fs/kernfs/dir.c
> @@ -576,7 +576,7 @@ static int kernfs_dop_revalidate(struct dentry *dentry, unsigned int flags)
>  
>  	/* The kernfs node has been moved to a different namespace */
>  	if (kn->parent && kernfs_ns_enabled(kn->parent) &&
> -	    kernfs_info(dentry->d_sb)->ns != kn->ns)
> +	    kernfs_info(dentry->d_sb)->ns[kn->ns_type] != kn->ns)
>  		goto out_bad;
>  
>  	mutex_unlock(&kernfs_mutex);
> @@ -1087,7 +1087,7 @@ static struct dentry *kernfs_iop_lookup(struct inode *dir,
>  	mutex_lock(&kernfs_mutex);
>  
>  	if (kernfs_ns_enabled(parent))
> -		ns = kernfs_info(dir->i_sb)->ns;
> +		ns = kernfs_info(dir->i_sb)->ns[parent->ns_type];
>  
>  	kn = kernfs_find_ns(parent, dentry->d_name.name, ns);
>  
> @@ -1673,7 +1673,7 @@ static int kernfs_fop_readdir(struct file *file, struct dir_context *ctx)
>  	mutex_lock(&kernfs_mutex);
>  
>  	if (kernfs_ns_enabled(parent))
> -		ns = kernfs_info(dentry->d_sb)->ns;
> +		ns = kernfs_info(dentry->d_sb)->ns[parent->ns_type];
>  
>  	for (pos = kernfs_dir_pos(ns, parent, ctx->pos, pos);
>  	     pos;
> diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
> index 7ee97ef59184..7c972c00f84a 100644
> --- a/fs/kernfs/kernfs-internal.h
> +++ b/fs/kernfs/kernfs-internal.h
> @@ -16,6 +16,7 @@
>  #include <linux/xattr.h>
>  
>  #include <linux/kernfs.h>
> +#include <linux/kobject_ns.h>
>  #include <linux/fs_context.h>
>  
>  struct kernfs_iattrs {
> @@ -62,12 +63,10 @@ struct kernfs_super_info {
>  	struct kernfs_root	*root;
>  
>  	/*
> -	 * Each sb is associated with one namespace tag, currently the
> -	 * network namespace of the task which mounted this kernfs
> -	 * instance.  If multiple tags become necessary, make the following
> -	 * an array and compare kernfs_node tag against every entry.
> +	 * Each sb can be associated with namespace tags. They will be used
> +	 * to compare kernfs_node tags against relevant entries.
>  	 */
> -	const void		*ns;
> +	const void		*ns[KOBJ_NS_TYPES];
>  
>  	/* anchored at kernfs_root->supers, protected by kernfs_mutex */
>  	struct list_head	node;
> diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> index 9dc7e7a64e10..dc4ee0f0a597 100644
> --- a/fs/kernfs/mount.c
> +++ b/fs/kernfs/mount.c
> @@ -279,14 +279,15 @@ static int kernfs_test_super(struct super_block *sb, struct fs_context *fc)
>  	struct kernfs_super_info *sb_info = kernfs_info(sb);
>  	struct kernfs_super_info *info = fc->s_fs_info;
>  
> -	return sb_info->root == info->root && sb_info->ns == info->ns;
> +	return sb_info->root == info->root &&
> +	       memcmp(sb_info->ns, info->ns, sizeof(sb_info->ns)) == 0;
>  }
>  
>  static int kernfs_set_super(struct super_block *sb, struct fs_context *fc)
>  {
>  	struct kernfs_fs_context *kfc = fc->fs_private;
>  
> -	kfc->ns_tag = NULL;
> +	memset(kfc->ns_tag, 0, sizeof(kfc->ns_tag));
>  	return set_anon_super_fc(sb, fc);
>  }
>  
> @@ -296,7 +297,7 @@ static int kernfs_set_super(struct super_block *sb, struct fs_context *fc)
>   *
>   * Return the namespace tag associated with kernfs super_block @sb.
>   */
> -const void *kernfs_super_ns(struct super_block *sb)
> +const void **kernfs_super_ns(struct super_block *sb)
>  {
>  	struct kernfs_super_info *info = kernfs_info(sb);
>  
> @@ -324,7 +325,9 @@ int kernfs_get_tree(struct fs_context *fc)
>  		return -ENOMEM;
>  
>  	info->root = kfc->root;
> -	info->ns = kfc->ns_tag;
> +	BUILD_BUG_ON(sizeof(info->ns) != sizeof(kfc->ns_tag));
> +	memcpy(info->ns, kfc->ns_tag, sizeof(info->ns));
> +
>  	INIT_LIST_HEAD(&info->node);
>  
>  	fc->s_fs_info = info;
> diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
> index db81cfbab9d6..5e2ec88a709e 100644
> --- a/fs/sysfs/mount.c
> +++ b/fs/sysfs/mount.c
> @@ -41,8 +41,8 @@ static void sysfs_fs_context_free(struct fs_context *fc)
>  {
>  	struct kernfs_fs_context *kfc = fc->fs_private;
>  
> -	if (kfc->ns_tag)
> -		kobj_ns_drop(KOBJ_NS_TYPE_NET, kfc->ns_tag);
> +	if (kfc->ns_tag[KOBJ_NS_TYPE_NET])
> +		kobj_ns_drop(KOBJ_NS_TYPE_NET, kfc->ns_tag[KOBJ_NS_TYPE_NET]);
>  	kernfs_free_fs_context(fc);
>  	kfree(kfc);
>  }
> @@ -66,7 +66,7 @@ static int sysfs_init_fs_context(struct fs_context *fc)
>  	if (!kfc)
>  		return -ENOMEM;
>  
> -	kfc->ns_tag = netns = kobj_ns_grab_current(KOBJ_NS_TYPE_NET);
> +	kfc->ns_tag[KOBJ_NS_TYPE_NET] = netns = kobj_ns_grab_current(KOBJ_NS_TYPE_NET);
>  	kfc->root = sysfs_root;
>  	kfc->magic = SYSFS_MAGIC;
>  	fc->fs_private = kfc;
> @@ -81,10 +81,10 @@ static int sysfs_init_fs_context(struct fs_context *fc)
>  
>  static void sysfs_kill_sb(struct super_block *sb)
>  {
> -	void *ns = (void *)kernfs_super_ns(sb);
> +	void **ns = (void **)kernfs_super_ns(sb);
>  
>  	kernfs_kill_sb(sb);
> -	kobj_ns_drop(KOBJ_NS_TYPE_NET, ns);
> +	kobj_ns_drop(KOBJ_NS_TYPE_NET, ns[KOBJ_NS_TYPE_NET]);
>  }
>  
>  static struct file_system_type sysfs_fs_type = {
> diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> index 89f6a4214a70..d0544f2e0c99 100644
> --- a/include/linux/kernfs.h
> +++ b/include/linux/kernfs.h
> @@ -16,6 +16,7 @@
>  #include <linux/atomic.h>
>  #include <linux/uidgid.h>
>  #include <linux/wait.h>
> +#include <linux/kobject_ns.h>
>  
>  struct file;
>  struct dentry;
> @@ -137,8 +138,9 @@ struct kernfs_node {
>  
>  	struct rb_node		rb;
>  
> -	const void		*ns;	/* namespace tag */
> -	unsigned int		hash;	/* ns + name hash */
> +	const void		*ns;		/* namespace tag */
> +	enum kobj_ns_type	ns_type;	/* type of namespace tag */
> +	unsigned int		hash;		/* ns + name hash */
>  	union {
>  		struct kernfs_elem_dir		dir;
>  		struct kernfs_elem_symlink	symlink;
> @@ -275,7 +277,7 @@ struct kernfs_ops {
>   */
>  struct kernfs_fs_context {
>  	struct kernfs_root	*root;		/* Root of the hierarchy being mounted */
> -	void			*ns_tag;	/* Namespace tag of the mount (or NULL) */
> +	void			*ns_tag[KOBJ_NS_TYPES]; /* Namespace tags of the mount (or empty) */
>  	unsigned long		magic;		/* File system specific magic number */
>  
>  	/* The following are set/used by kernfs_mount() */
> @@ -319,17 +321,20 @@ static inline ino_t kernfs_gen(struct kernfs_node *kn)
>  
>  /**
>   * kernfs_enable_ns - enable namespace under a directory
> - * @kn: directory of interest, should be empty
> + * @kn:		directory of interest, should be empty
> + * @ns_type:	type of namespace that should be enabled for this directory
>   *
>   * This is to be called right after @kn is created to enable namespace
>   * under it.  All children of @kn must have non-NULL namespace tags and
>   * only the ones which match the super_block's tag will be visible.
>   */
> -static inline void kernfs_enable_ns(struct kernfs_node *kn)
> +static inline void kernfs_enable_ns(struct kernfs_node *kn,
> +				    enum kobj_ns_type ns_type)
>  {
>  	WARN_ON_ONCE(kernfs_type(kn) != KERNFS_DIR);
>  	WARN_ON_ONCE(!RB_EMPTY_ROOT(&kn->dir.children));
>  	kn->flags |= KERNFS_NS;
> +	kn->ns_type = ns_type;
>  }
>  
>  /**
> @@ -401,7 +406,7 @@ int kernfs_xattr_get(struct kernfs_node *kn, const char *name,
>  int kernfs_xattr_set(struct kernfs_node *kn, const char *name,
>  		     const void *value, size_t size, int flags);
>  
> -const void *kernfs_super_ns(struct super_block *sb);
> +const void **kernfs_super_ns(struct super_block *sb);
>  int kernfs_get_tree(struct fs_context *fc);
>  void kernfs_free_fs_context(struct fs_context *fc);
>  void kernfs_kill_sb(struct super_block *sb);
> @@ -415,7 +420,8 @@ struct kernfs_node *kernfs_find_and_get_node_by_id(struct kernfs_root *root,
>  static inline enum kernfs_node_type kernfs_type(struct kernfs_node *kn)
>  { return 0; }	/* whatever */
>  
> -static inline void kernfs_enable_ns(struct kernfs_node *kn) { }
> +static inline void kernfs_enable_ns(struct kernfs_node *kn,
> +				    enum kobj_ns_type ns_type) { }
>  
>  static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
>  { return false; }
> @@ -511,7 +517,7 @@ static inline int kernfs_xattr_set(struct kernfs_node *kn, const char *name,
>  				   const void *value, size_t size, int flags)
>  { return -ENOSYS; }
>  
> -static inline const void *kernfs_super_ns(struct super_block *sb)
> +static inline const void **kernfs_super_ns(struct super_block *sb)
>  { return NULL; }
>  
>  static inline int kernfs_get_tree(struct fs_context *fc)
> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> index 80bb865b3a33..d127b3487abc 100644
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -306,9 +306,10 @@ void sysfs_notify(struct kobject *kobj, const char *dir, const char *attr);
>  
>  int __must_check sysfs_init(void);
>  
> -static inline void sysfs_enable_ns(struct kernfs_node *kn)
> +static inline void sysfs_enable_ns(struct kernfs_node *kn,
> +				   enum kobj_ns_type ns_type)
>  {
> -	return kernfs_enable_ns(kn);
> +	return kernfs_enable_ns(kn, ns_type);
>  }
>  
>  int sysfs_file_change_owner(struct kobject *kobj, const char *name, kuid_t kuid,
> @@ -531,7 +532,8 @@ static inline int __must_check sysfs_init(void)
>  	return 0;
>  }
>  
> -static inline void sysfs_enable_ns(struct kernfs_node *kn)
> +static inline void sysfs_enable_ns(struct kernfs_node *kn,
> +				   enum kobj_ns_type ns_type)
>  {
>  }
>  
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 6f07083cc111..c58c62d49a10 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -120,7 +120,7 @@ static int create_dir(struct kobject *kobj)
>  		BUG_ON(ops->type >= KOBJ_NS_TYPES);
>  		BUG_ON(!kobj_ns_type_registered(ops->type));
>  
> -		sysfs_enable_ns(kobj->sd);
> +		sysfs_enable_ns(kobj->sd, ops->type);
>  	}
>  
>  	return 0;
> -- 
> 2.26.1
